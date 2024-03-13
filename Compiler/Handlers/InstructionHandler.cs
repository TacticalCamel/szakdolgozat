﻿namespace Compiler.Handlers;

using System.Collections;
using Interpreter.Bytecode;

internal sealed class InstructionHandler: IEnumerable<Instruction> {
    private List<Instruction> Instructions { get; } = [];
    
    public IEnumerator<Instruction> GetEnumerator() {
        return Instructions.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator() {
        return GetEnumerator();
    }
}