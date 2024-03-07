﻿namespace Compiler.Data;

using System.Runtime.InteropServices;
using Runtime.Core;

internal sealed unsafe class DataHandler {
    private int DataLength { get; set; }
    private List<Hole> Holes { get; }

    public IObjectCollection<I8> I8 { get; }
    public IObjectCollection<I16> I16 { get; }
    public IObjectCollection<I32> I32 { get; }
    public IObjectCollection<I64> I64 { get; }
    public IObjectCollection<U8> U8 { get; }
    public IObjectCollection<U16> U16 { get; }
    public IObjectCollection<U32> U32 { get; }
    public IObjectCollection<U64> U64 { get; }
    public IObjectCollection<F16> F16 { get; }
    public IObjectCollection<F32> F32 { get; }
    public IObjectCollection<F64> F64 { get; }
    public IObjectCollection<Bool> Bool { get; }
    public IObjectCollection<Char> Char { get; }
    public IObjectCollection<string> Str { get; }

    public DataHandler() {
        DataLength = 0;
        Holes = [];
        
        I8 = new PrimitiveCollection<I8>(this);
        I16 = new PrimitiveCollection<I16>(this);
        I32 = new PrimitiveCollection<I32>(this);
        I64 = new PrimitiveCollection<I64>(this);
        U8 = new PrimitiveCollection<U8>(this);
        U16 = new PrimitiveCollection<U16>(this);
        U32 = new PrimitiveCollection<U32>(this);
        U64 = new PrimitiveCollection<U64>(this);
        F16 = new PrimitiveCollection<F16>(this);
        F32 = new PrimitiveCollection<F32>(this);
        F64 = new PrimitiveCollection<F64>(this);
        Bool = new PrimitiveCollection<Bool>(this);
        Char = new PrimitiveCollection<Char>(this);
        Str = new StringCollection(this);
    }

    private int AddObject(int size) {
        int round = sizeof(IntPtr);
        
        if (size % round != 0) {
            int index = -1;

            for (int i = 0; i < Holes.Count; i++) {
                if(Holes[i].Size < size) continue;
                index = i;
                break;
            }

            if (index < 0) {
                int address = DataLength;
                int roundedSize = RoundUp(size, round);

                Holes.Add(new Hole(address + size, roundedSize - size));
                DataLength += roundedSize;
                
                return address;
            }
            else {
                int address = Holes[index].Address;
                
                Hole hole = new(Holes[index].Address + size, Holes[index].Size - size);

                if (hole.Size < 1) {
                    Holes.RemoveAt(index);
                }
                else {
                    Holes[index] = hole;
                }

                return address;
            }
        }

        {
            int address = DataLength;

            DataLength += size;

            return address;
        }
    }
    
    public byte[] ToBytes() {
        int length = RoundUp(DataLength, 16);
        byte[] bytes = new byte[length];

        I8.WriteContents(bytes);
        I16.WriteContents(bytes);
        I32.WriteContents(bytes);
        I64.WriteContents(bytes);
        U8.WriteContents(bytes);
        U16.WriteContents(bytes);
        U32.WriteContents(bytes);
        U64.WriteContents(bytes);
        F16.WriteContents(bytes);
        F32.WriteContents(bytes);
        F64.WriteContents(bytes);
        Bool.WriteContents(bytes);
        Char.WriteContents(bytes);
        Str.WriteContents(bytes);
        
        return bytes;
    }
    
    private static int RoundUp(int value, int factor) {
        return (value + factor - 1) / factor * factor;
    }

    #region Types
    
    public interface IObjectCollection<in T> {
        public int Add(T value);
        public void WriteContents(byte[] bytes);
    }
    
    private sealed class PrimitiveCollection<T>(DataHandler dataHandler): IObjectCollection<T> where T : unmanaged {
        private DataHandler DataHandler { get; } = dataHandler;
        private Dictionary<T, int> Objects { get; } = [];
        private int ObjectSize { get; } = sizeof(T);

        public int Add(T value) {
            bool contains = Objects.TryGetValue(value, out int address);

            if (contains) {
                return address;
            }

            address = DataHandler.AddObject(ObjectSize);

            Objects.Add(value, address);

            return address;
        }

        public void WriteContents(byte[] bytes) {
            foreach (KeyValuePair<T, int> pair in Objects) {
                Span<byte> destination = bytes.AsSpan(pair.Value);
                MemoryMarshal.Write(destination, pair.Key);
            }
        }
    }

    private sealed class StringCollection(DataHandler dataHandler): IObjectCollection<string> {
        private DataHandler DataHandler { get; } = dataHandler;
        private Dictionary<string, int> Objects { get; } = [];

        public int Add(string value) {
            bool contains = Objects.TryGetValue(value, out int address);

            if (contains) {
                return address;
            }

            address = DataHandler.AddObject(sizeof(int) + value.Length * sizeof(char));
            
            Objects.Add(value, address);

            return address;
        }
        
        public void WriteContents(byte[] bytes) {
            foreach (KeyValuePair<string, int> pair in Objects) {
                Span<byte> destination = bytes.AsSpan(pair.Value);
                
                MemoryMarshal.Write(destination, pair.Key.Length);

                ReadOnlySpan<byte> characterBytes = MemoryMarshal.Cast<char, byte>(pair.Key);
                
                characterBytes.CopyTo(destination[sizeof(int)..]);
            }
        }
    }

    private readonly struct Hole(int address, int size) {
        public readonly int Address = address;
        public readonly int Size = size;
    }
    
    #endregion
}