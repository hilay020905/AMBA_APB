module APB_Memory_tb();

    // Register declarations for controlling the DUT
    reg Pclk, Prst, Pselx, Penable, Pwrite;
    reg [31:0] Pwdata;
    reg [4:0] Paddr;

    // Wire declarations to monitor outputs from the DUT
    wire Pready, Pslverr;
    wire [31:0] Prdata, temp;

    // Device Under Test (DUT)
    APB_Memory DUT(
        .Pclk(Pclk),
        .Prst(Prst),
        .Paddr(Paddr),
        .Pselx(Pselx),
        .Penable(Penable),
        .Pwrite(Pwrite),
        .Pwdata(Pwdata),
        .Pready(Pready),
        .Pslverr(Pslverr),
        .Prdata(Prdata),
        .temp(temp)
    );

    // Clock generation (50% duty cycle)
    initial Pclk = 0;
    always #10 Pclk = ~Pclk; // Toggle clock every 10 time units

    // Task for initializing and resetting the DUT
    task reset_and_init;
        begin
            #5 Prst = 0;            // Assert reset
            @(posedge Pclk);       // Wait for a clock edge
            Prst = 1;              // Deassert reset
            Pselx = 1'b0;          // Deactivate slave select
            Penable = 1'bx;        // Unknown state for enable
            Pwrite = 1'bx;         // Unknown state for write
            Paddr = 'bx;           // Unknown state for address
        end
    endtask

    // Task for performing a write operation
    task write_transfer;
        begin
            Pselx = 1;             // Activate slave select
            Pwrite = 1;            // Set write operation
            Pwdata = $random;     // Random data
            Paddr = $random % 32; // Random address within bounds
            
            @(posedge Pclk)
            Penable = 1;           // Enable the operation
            
            wait(Pready == 1)      // Wait until ready signal is asserted
            
            @(posedge Pclk);
            Penable = 0;           // Disable the operation
            
            $strobe("Writing Data into memory: Data = %0d | Address = %0d", Pwdata, Paddr);
        end
    endtask

    // Task for performing a read operation
    task read_transfer;
        begin
            Pselx = 1;             // Activate slave select
            Pwrite = 0;            // Set read operation
            
            @(posedge Pclk);
            Penable = 1;           // Enable the operation
            
            @(posedge Pclk);
            Penable = 0;           // Disable the operation
            Pselx = 0;             // Deactivate slave select
            
            $strobe("Reading Data From Memory: Data = %0d | Address = %0d", Prdata, Paddr);
        end
    endtask

    // Task to perform multiple read and write transfers
    task read_write_transfer;
        begin
            repeat(5)
                begin
                    write_transfer; // Execute write operation
                    read_transfer;  // Execute read operation
                end
        end
    endtask

    // Initial block to execute the tests
    initial begin
        reset_and_init;          // Reset and initialize the DUT
        read_write_transfer;     // Perform read/write operations
        #80;                     // Wait for some time
        $finish;                 // End the simulation
    end
endmodule