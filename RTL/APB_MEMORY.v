module APB_Memory(
    input Pclk,          // Clock signal
    input Prst,          // Asynchronous reset signal (active low)
    input [4:0] Paddr,   // Address bus (5-bit)
    input Pselx,         // Slave select signal (only one slave in this design)
    input Penable,       // Enable signal for the transfer
    input Pwrite,        // Write signal (1 for write, 0 for read)
    input [31:0] Pwdata, // Write data bus (32-bit)
    output reg Pready,   // Ready signal (indicates slave is ready)
    output reg Pslverr,  // Slave error signal (indicates an error)
    output reg [31:0] Prdata, // Read data bus (32-bit)
    output reg [31:0] temp     // Temporary register for storing data
);

    // Memory Declaration
    reg [31:0] mem [31:0]; // 32x32-bit memory array

    // State Declaration
    parameter [1:0] idle = 2'b00,   // Idle state
                    setup = 2'b01,  // Setup state
                    access = 2'b10; // Access state

    // Present and next state declaration
    reg [1:0] present_state, next_state;

    // Asynchronous Active Low Reset
    always @(posedge Pclk or negedge Prst) begin
        if (Prst == 0) begin
            present_state <= idle; // Reset to idle state
        end else begin
            present_state <= next_state; // Move to the next state
        end
    end

    // State transition and output logic
    always @(*) begin
        // Default assignments
        Pready = 0;
        Pslverr = 0;
        Prdata = 32'bz; // High-impedance state when not reading

        case (present_state)
            idle: begin
                next_state = setup; // Move to setup state from idle
            end

            setup: begin
                if (Pselx) begin
                    next_state = access; // If selected, move to access state
                end else begin
                    next_state = idle; // Remain in idle if not selected
                end
            end

            access: begin
                Pready = 1'b1; // Slave is ready for transfer
                if (Pwrite == 1 && Penable == 1) begin
                    // Write operation
                    if (Paddr > 31) begin
                        Pslverr = 1; // Error if address exceeds memory size
                    end else begin
                        mem[Paddr] = Pwdata; // Write data to memory
                        temp = mem[Paddr];   // Store data in temp for verification
                        Pslverr = 1'b0;      // Clear error flag
                    end
                end else if (Penable && Pwrite == 0) begin
                    // Read operation
                    Prdata = mem[Paddr]; // Read data from memory
                end else if (!Penable) begin
                    next_state = idle; // Return to idle if not enabled
                end
            end
        endcase
    end

endmodule