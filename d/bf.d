void main(in string[] args)
{
    import std.array, std.file, std.regex, std.stdio;

    char[] program;
    if (args.length > 1)
        program = cast(char[])read(args[1]);
    else
        stdin.readf("%s", program);

    auto re = regex(r"[^><\+\-.,\[\]]");
    program = program.replaceAll(re, "");
    ulong len = program.length;

    int[int] jumps;
    int[] stack;

    foreach (int i, char c; program)
        if (c == '[')
        {
            stack ~= i;
        }
        else if (c == ']')
        {
            if (stack.empty)
                throw new Exception("unmatched ']'");

            int j = stack.back;
            stack.popBack();
            jumps[i] = j;
            jumps[j] = i;
        }

    if (!stack.empty)
        throw new Exception("unmatched '['");

    char[65536] tape = '\0';
    ushort ptr;

    for (int i = 0; i < len; ++i)
        switch (program[i])
        {
            case '>':
                ++ptr;
                break;
            case '<':
                --ptr;
                break;
            case '+':
                ++tape[ptr];
                break;
            case '-':
                --tape[ptr];
                break;
            case '.':
                putchar(tape[ptr]);
                stdout.flush();
                break;
            case ',':
                int c = getchar();
                if (c != EOF) {
                    tape[ptr] = cast(char)c;
                } else {
                    stdin.clearerr();
                }
                break;
            case '[':
                if (!tape[ptr])
                    i = jumps[i];
                break;
            case ']':
                if (tape[ptr])
                    i = jumps[i];
                break;
            default:
                break;
        }
}