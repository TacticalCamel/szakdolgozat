﻿namespace Compiler.Handlers;

using Data;
using System.Collections;
using Interpreter.Bytecode;

internal sealed class InstructionHandler : IEnumerable<Instruction> {
    private List<Instruction> Instructions { get; } = [];
    private uint StackSize { get; set; }

    public IEnumerator<Instruction> GetEnumerator() {
        return Instructions.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator() {
        return GetEnumerator();
    }

    public void PushFromData(ExpressionResult expression, byte size) {
        Instructions.Add(new Instruction {
            Code = OperationCode.pshd,
            DataAddress = (int)expression.Address.Value,
            Size = size
        });

        StackSize += size;
    }

    public MemoryAddress AddInt(byte size) {
        Instructions.Add(new Instruction {
            Code = OperationCode.addi,
            Size = size
        });

        StackSize -= size;

        return new MemoryAddress(StackSize - size, MemoryLocation.Stack);
    }

    public void Add(Instruction instruction) {
        Instructions.Add(instruction);
    }
}