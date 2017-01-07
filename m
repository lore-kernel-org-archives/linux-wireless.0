Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44250 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755850AbdAGNts (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 08:49:48 -0500
Date: Sat, 7 Jan 2017 21:57:15 +0800
From: kbuild test robot <lkp@intel.com>
To: Rahul Krishnan <mrahul.krishnan@gmail.com>
Cc: kbuild-all@01.org, m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ssb: main.c: This patch removes unnecessary return
 statement using spatch tool
Message-ID: <201701072126.jdMVQyVN%fengguang.wu@intel.com> (sfid-20170107_145014_395626_3A80C73E)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
In-Reply-To: <20170106152043.GA6383@rahul>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rahul,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.10-rc2 next-20170106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rahul-Krishnan/ssb-main-c-This-patch-removes-unnecessary-return-statement-using-spatch-tool/20170107-205451
config: i386-randconfig-r0-201701 (attached as .config)
compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/ssb/main.c:1:8: error: expected '=', ',', ';', 'asm' or '__attribute__' before '/' token
     patch /home/rahul/git/kernels/staging/drivers//*
           ^
   drivers/ssb/main.c:6:43: error: stray '@' in program
     * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
                                              ^
   In file included from include/linux/ioport.h:12:0,
                    from include/linux/device.h:16,
                    from include/linux/ssb/ssb.h:4,
                    from drivers/ssb/ssb_private.h:4,
                    from drivers/ssb/main.c:11:
>> include/linux/compiler.h:110:34: warning: 'struct ftrace_branch_data' declared inside parameter list
    void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
                                     ^
>> include/linux/compiler.h:110:34: warning: its scope is only this definition or declaration, which is probably not what you want
   include/linux/err.h: In function 'IS_ERR':
   include/linux/compiler.h:117:18: error: variable '______f' has initializer but incomplete type
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/compiler.h:117:18: error: unknown field 'func' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/compiler.h:121:13: warning: excess elements in struct initializer
        .func = __func__,   \
                ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/compiler.h:121:13: note: (near initialization for '______f')
        .func = __func__,   \
                ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/compiler.h:117:18: error: unknown field 'file' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/err.h:35:40: warning: excess elements in struct initializer
     return IS_ERR_VALUE((unsigned long)ptr);
                                           ^
   include/linux/err.h:35:40: note: (near initialization for '______f')
   include/linux/compiler.h:117:18: error: unknown field 'line' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/err.h:35:40: warning: excess elements in struct initializer
     return IS_ERR_VALUE((unsigned long)ptr);
                                           ^
   include/linux/err.h:35:40: note: (near initialization for '______f')
   include/linux/compiler.h:120:5: error: storage size of '______f' isn't known
        ______f = {    \
        ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
                            ^
   include/linux/err.h:35:9: note: in expansion of macro 'IS_ERR_VALUE'
     return IS_ERR_VALUE((unsigned long)ptr);
            ^
   include/linux/compiler.h:120:5: warning: unused variable '______f' [-Wunused-variable]
        ______f = {    \
        ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   include/linux/err.h:21:25: note: in expansion of macro 'unlikely'
--
            ^
   include/linux/compiler.h:121:13: note: (near initialization for '______f')
        .func = __func__,   \
                ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   arch/x86/include/asm/preempt.h:98:9: note: in expansion of macro 'unlikely'
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
            ^
   include/linux/compiler.h:117:18: error: unknown field 'file' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   arch/x86/include/asm/preempt.h:98:9: note: in expansion of macro 'unlikely'
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
            ^
   arch/x86/include/asm/preempt.h:98:67: warning: excess elements in struct initializer
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
                                                                      ^
   arch/x86/include/asm/preempt.h:98:67: note: (near initialization for '______f')
   include/linux/compiler.h:117:18: error: unknown field 'line' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   arch/x86/include/asm/preempt.h:98:9: note: in expansion of macro 'unlikely'
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
            ^
   arch/x86/include/asm/preempt.h:98:67: warning: excess elements in struct initializer
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
                                                                      ^
   arch/x86/include/asm/preempt.h:98:67: note: (near initialization for '______f')
   include/linux/compiler.h:120:5: error: storage size of '______f' isn't known
        ______f = {    \
        ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   arch/x86/include/asm/preempt.h:98:9: note: in expansion of macro 'unlikely'
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
            ^
   include/linux/compiler.h:120:5: warning: unused variable '______f' [-Wunused-variable]
        ______f = {    \
        ^
   include/linux/compiler.h:139:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^
   arch/x86/include/asm/preempt.h:98:9: note: in expansion of macro 'unlikely'
     return unlikely(raw_cpu_read_4(__preempt_count) == preempt_offset);
            ^
   include/asm-generic/qspinlock.h: In function 'queued_spin_lock':
   include/linux/compiler.h:117:18: error: variable '______f' has initializer but incomplete type
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/linux/compiler.h:117:18: error: unknown field 'func' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/linux/compiler.h:121:13: warning: excess elements in struct initializer
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/linux/compiler.h:121:13: note: (near initialization for '______f')
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/linux/compiler.h:117:18: error: unknown field 'file' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
>> include/asm-generic/qspinlock.h:101:21: warning: excess elements in struct initializer
     if (likely(val == 0))
                        ^
   include/asm-generic/qspinlock.h:101:21: note: (near initialization for '______f')
   include/linux/compiler.h:117:18: error: unknown field 'line' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
>> include/asm-generic/qspinlock.h:101:21: warning: excess elements in struct initializer
     if (likely(val == 0))
                        ^
   include/asm-generic/qspinlock.h:101:21: note: (near initialization for '______f')
   include/linux/compiler.h:120:5: error: storage size of '______f' isn't known
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/linux/compiler.h:120:5: warning: unused variable '______f' [-Wunused-variable]
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qspinlock.h:101:6: note: in expansion of macro 'likely'
     if (likely(val == 0))
         ^
   include/asm-generic/qrwlock.h: In function 'queued_read_trylock':
   include/linux/compiler.h:117:18: error: variable '______f' has initializer but incomplete type
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:117:18: error: unknown field 'func' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:121:13: warning: excess elements in struct initializer
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:121:13: note: (near initialization for '______f')
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:117:18: error: unknown field 'file' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
>> include/asm-generic/qrwlock.h:83:32: warning: excess elements in struct initializer
     if (likely(!(cnts & _QW_WMASK))) {
                                   ^
   include/asm-generic/qrwlock.h:83:32: note: (near initialization for '______f')
   include/linux/compiler.h:117:18: error: unknown field 'line' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
>> include/asm-generic/qrwlock.h:83:32: warning: excess elements in struct initializer
     if (likely(!(cnts & _QW_WMASK))) {
                                   ^
   include/asm-generic/qrwlock.h:83:32: note: (near initialization for '______f')
   include/linux/compiler.h:120:5: error: storage size of '______f' isn't known
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:120:5: warning: unused variable '______f' [-Wunused-variable]
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:83:6: note: in expansion of macro 'likely'
     if (likely(!(cnts & _QW_WMASK))) {
         ^
   include/linux/compiler.h:117:18: error: variable '______f' has initializer but incomplete type
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/linux/compiler.h:117:18: error: unknown field 'func' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/linux/compiler.h:121:13: warning: excess elements in struct initializer
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/linux/compiler.h:121:13: note: (near initialization for '______f')
        .func = __func__,   \
                ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/linux/compiler.h:117:18: error: unknown field 'file' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/asm-generic/qrwlock.h:85:33: warning: excess elements in struct initializer
      if (likely(!(cnts & _QW_WMASK)))
                                    ^
   include/asm-generic/qrwlock.h:85:33: note: (near initialization for '______f')
   include/linux/compiler.h:117:18: error: unknown field 'line' specified in initializer
       static struct ftrace_branch_data  \
                     ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/asm-generic/qrwlock.h:85:33: warning: excess elements in struct initializer
      if (likely(!(cnts & _QW_WMASK)))
                                    ^
   include/asm-generic/qrwlock.h:85:33: note: (near initialization for '______f')
   include/linux/compiler.h:120:5: error: storage size of '______f' isn't known
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
          ^
   include/linux/compiler.h:120:5: warning: unused variable '______f' [-Wunused-variable]
        ______f = {    \
        ^
   include/linux/compiler.h:136:56: note: in expansion of macro '__branch_check__'
    #  define likely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 1))
                                                           ^
   include/asm-generic/qrwlock.h:85:7: note: in expansion of macro 'likely'
      if (likely(!(cnts & _QW_WMASK)))
..

vim +212 drivers/ssb/main.c

3ba6018a Michael Buesch 2009-11-23  196   *
3ba6018a Michael Buesch 2009-11-23  197   * After freezing no device driver will be handling a device
3ba6018a Michael Buesch 2009-11-23  198   * on this bus anymore. ssb_devices_thaw() must be called after
3ba6018a Michael Buesch 2009-11-23  199   * a successful freeze to reactivate the devices.
3ba6018a Michael Buesch 2009-11-23  200   *
3ba6018a Michael Buesch 2009-11-23  201   * @bus: The bus.
3ba6018a Michael Buesch 2009-11-23  202   * @ctx: Context structure. Pass this to ssb_devices_thaw().
3ba6018a Michael Buesch 2009-11-23  203   */
3ba6018a Michael Buesch 2009-11-23  204  int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_freeze_context *ctx)
61e115a5 Michael Buesch 2007-09-18  205  {
3ba6018a Michael Buesch 2009-11-23  206  	struct ssb_device *sdev;
3ba6018a Michael Buesch 2009-11-23  207  	struct ssb_driver *sdrv;
3ba6018a Michael Buesch 2009-11-23  208  	unsigned int i;
3ba6018a Michael Buesch 2009-11-23  209  
3ba6018a Michael Buesch 2009-11-23  210  	memset(ctx, 0, sizeof(*ctx));
3ba6018a Michael Buesch 2009-11-23  211  	ctx->bus = bus;
3ba6018a Michael Buesch 2009-11-23 @212  	SSB_WARN_ON(bus->nr_devices > ARRAY_SIZE(ctx->device_frozen));
61e115a5 Michael Buesch 2007-09-18  213  
61e115a5 Michael Buesch 2007-09-18  214  	for (i = 0; i < bus->nr_devices; i++) {
3ba6018a Michael Buesch 2009-11-23  215  		sdev = ssb_device_get(&bus->devices[i]);
3ba6018a Michael Buesch 2009-11-23  216  
3ba6018a Michael Buesch 2009-11-23  217  		if (!sdev->dev || !sdev->dev->driver ||
3ba6018a Michael Buesch 2009-11-23  218  		    !device_is_registered(sdev->dev)) {
3ba6018a Michael Buesch 2009-11-23  219  			ssb_device_put(sdev);
61e115a5 Michael Buesch 2007-09-18  220  			continue;

:::::: The code at line 212 was first introduced by commit
:::::: 3ba6018aa314559c5867138a8173b068268a70db ssb: Fix SPROM writing

:::::: TO: Michael Buesch <mb@bu3sch.de>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--9amGYk9869ThD9tj
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--9amGYk9869ThD9tj--
