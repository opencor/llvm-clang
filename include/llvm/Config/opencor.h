#ifndef OPENCOR_H
#define OPENCOR_H

#ifdef _WIN32
    #ifdef LLVMCLANG_BUILD_SHARED_LIB
        #define LLVMCLANG_EXPORT __declspec(dllexport)
    #else
        #define LLVMCLANG_EXPORT __declspec(dllimport)
    #endif
#else
    #define LLVMCLANG_EXPORT
#endif

class NonCopyable
{
    protected:
        NonCopyable() = default;
        NonCopyable(const NonCopyable &) = delete;
        ~NonCopyable() = default;

        const NonCopyable & operator=(const NonCopyable &) = delete;
};

#endif
