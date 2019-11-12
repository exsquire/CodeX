#kernGeist

kernGeist is another meta-coding project, or "code that writes code". 

The problem: In research, code parameters can be easily changed without thought to version control. 
We need a way to keep script parameters separate from code that actually runs the scripts for documentation purposes.
KernGeist essentially makes any R function interactive and then stores/documents the parameters submitted to the function. 

The result is a "caRtridge" that can be sourced in place of the actual function call, with all the arguments pre-loaded. 

