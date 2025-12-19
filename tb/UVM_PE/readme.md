# PE Verification Environment Usage Guide

## 📋 Overview

This Makefile provides a complete compilation, simulation, and coverage collection workflow for the PE (Processing Element) UVM verification environment. It supports multiple configuration options, flexible test scenario execution, and multi-seed coverage merging capabilities.

## 🚀 Quick Start

### Basic Usage

```bash
cd sim
make clean
# 1. Compile and run default test (PE_test_all, multiseed, Pipeline mode)
make

# 2. Check coverage in verdi
make view-merged-cov

# 3. Check coverage in html
make gen-html-report

# 4. Compile only(PE_test_all, SEED=2, Pipeline mode)
make comp

# 5. Simulate only (requires compilation first)
make sim

# 6. View current configuration
make show-config
```

## ⚙️ Configuration Options

### Command-line Configurable Parameters

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `TESTNAME` | `PE_test_all` | Test case name |
| `SEED` | `2` | Random seed |
| `VERB` | `UVM_LOW` | UVM verbosity level |
| `FSDB_NAME` | `PE_test` | FSDB waveform filename |
| `Is_Not_PipLine` | Not set | Set to 1 to disable Pipeline mode |

### Test Case Options

- `PE_test_all`: Run all tests (default)
- `PE_test_int`: Integer instructions tests
- `PE_test_fmop`: Floating-point outer product instructions tests
- `PE_test_fdot`: Floating-point inner product instructions tests
- `PE_test_bfmop`: Block floating-point instructions tests

### Verbosity Level Options

- `UVM_LOW`: Print only error messages (default)
- `UVM_MEDIUM`: Print input/output and result messages
- `UVM_HIGH`: Detailed debug information

## 📖 Detailed Usage

### Single Test Run

```bash
# Run specific test case
make TESTNAME=PE_test_int SEED=10
make TESTNAME=PE_test_fmop SEED=5 VERB=UVM_MEDIUM

# Using shortcut commands
make test-int          # PE_test_int, seed=2
make test-fmop SEED=3  # PE_test_fmop, seed=3
make test-fdot VERB=UVM_HIGH  # PE_test_fdot, high verbosity
make test-bfmop        # PE_test_bfmop
make test-all          # PE_test_all
```

### Batch Testing with Coverage Merging

```bash
# Run seeds 1-5 and automatically merge coverage (default test case)
make multi-seed

# Run multiple seeds for specified test case
make multi-seed TESTNAME=PE_test_int

# Using shortcut commands
make multi-seed-int     # PE_test_int, seeds 1-5
make multi-seed-fmop    # PE_test_fmop, seeds 1-5
make multi-seed-fdot    # PE_test_fdot, seeds 1-5
make multi-seed-bfmop   # PE_test_bfmop, seeds 1-5

# Custom seed range
make multi-seed-range
# Interactive input for start and end seed numbers
```

### Pipeline Mode Control

```bash
# Default: Pipeline mode enabled (+define+Is_PipLine)
make

# Disable Pipeline mode
make Is_Not_PipLine=1

# Specify test case and disable Pipeline
make Is_Not_PipLine=1 TESTNAME=PE_test_fmop
```

### Coverage Analysis and Reporting

```bash
# View merged coverage in verdi (requires multi-seed to be run first)
make view-merged-cov

# Generate HTML coverage report
make gen-html-report
# Report location: html_report/dashboard.html

# View waveforms with Verdi
make verdi

# View coverage with Verdi
make cov
```

### Cleanup Operations

```bash
# Clean all generated files
make clean

# Clean only compilation results, keep logs and coverage
make clean-comp

# Clean only coverage data
make clean-cov
```

## 🔧 Advanced Features

### Environment Dependencies

This environment depends on the following components:

1. **VCS**: Compilation and simulation tool
2. **Verdi**: Waveform and coverage viewing tool
3. **MPFR Library**: High-precision math library (C model dependency)
4. **UVM 1.1**: Verification methodology library

### C Model Integration

Makefile automatically compiles C reference model:
- Source code location: `../C_model/src/`
- Header files location: `../C_model/include/`
- MPFR library location: `/usr/local/include ` and `/usr/local/lib`
- Compilation options: Uses MPFR library for high-precision calculations

### Coverage Collection

Supports the following coverage types:
- **line**: Code line coverage
- **cond**: Condition coverage
- **fsm**: Finite state machine coverage
- **branch**: Branch coverage
- **tgl**: Toggle coverage
- **function** PE function coverage

## 📁 Directory Structure

```
.
├── Makefile                    # Main Makefile
├── filelist.f                  # Design file list
├── dump_fsdb_vcs.tcl           # FSDB waveform generation script
├── comp.log                    # Compilation log
├── sim.log                     # Simulation log
├── cov_seed*/                  # Per-seed coverage directories
├── merged_cov/                 # Merged coverage database
├── merged_cov_report/          # Merged coverage report
├── html_report/                # HTML coverage report
└── build_dir/                  # C model compilation directory
```

## ⚠️ Important Notes

1. **First Run**: Ensure MPFR library is correctly installed in location: `/usr/local/include ` and `/usr/local/lib`
2. **Environment Variables**: Ensure VCS, Verdi paths are properly set
3. **Disk Space**: Multi-seed testing generates significant data, monitor disk space
4. **Permissions**: Ensure read/write permissions for current directory
5. **Dependencies**: Recompile after RTL modifications (`make clean comp`)

## 🐛 Troubleshooting

### Common Issues

1. **Compilation Failure**
   - Check error messages in `comp.log`
   - Verify MPFR library paths are correct

2. **Simulation Failure**
   - Check UVM errors in `sim.log`
   - Verify test case names are correct

3. **Coverage Merging Failure**
   - Ensure `make multi-seed` has been run
   - Check if `urg` tool is available

4. **Verdi Cannot Open Waveforms**
   - Confirm FSDB files are generated
   - Check Verdi license

### Log File Descriptions

- **comp.log**: Detailed log of VCS compilation process
- **sim.log**: Output log from simulation runs
- **Per-seed directory logs**: Logs for each independent run

## 📞 Support

If issues occur:
1. Check relevant log files
2. Verify environment configuration
3. Contact the verification team for support

---

**Last Updated**: 2025/12/18 
**Version**: 1.0  