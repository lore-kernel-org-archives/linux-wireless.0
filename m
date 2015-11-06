Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11174 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033151AbbKFLt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 06:49:58 -0500
Date: Fri, 06 Nov 2015 19:49:15 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [linux-review:Johannes-Berg/mac80211-remove-string-from-unaligned-packet-warning/20151106-190240] f9bd23fdbf59a827b6b0e223522a00cf56c72a1b BUILD DONE
Message-ID: <563c93bb.o+0ERXkRwu8+zVAV%fengguang.wu@intel.com> (sfid-20151106_125002_008438_C2F160DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

https://github.com/0day-ci/linux  Johannes-Berg/mac80211-remove-string-from-unaligned-packet-warning/20151106-190240
f9bd23fdbf59a827b6b0e223522a00cf56c72a1b  mac80211: remove string from unaligned packet warning

include/asm-generic/bug.h:124:7: note: in expansion of macro 'WARN'
include/asm-generic/bug.h:74:72: error: expected expression before ')' token
include/asm-generic/bug.h:79:36: error: too few arguments to function 'printk'
include/asm-generic/bug.h:97:3: note: in expansion of macro '__WARN_printf'
net/mac80211/rx.c:664:2: error: expected expression before ')' token
net/mac80211/rx.c:664:2: error: too few arguments to function 'printk'
net/mac80211/rx.c:664:2: note: in expansion of macro 'WARN_ONCE'
net/mac80211/rx.c:664:9: sparse: not enough arguments for function warn_slowpath_fmt

Error ids grouped by kconfigs:

recent_errors
├── i386-allmodconfig
│   ├── include-asm-generic-bug.h:error:expected-expression-before-)-token
│   ├── include-asm-generic-bug.h:note:in-expansion-of-macro-WARN
│   ├── include-asm-generic-bug.h:note:in-expansion-of-macro-__WARN_printf
│   └── net-mac80211-rx.c:note:in-expansion-of-macro-WARN_ONCE
├── parisc-allyesconfig
│   └── include-asm-generic-bug.h:error:too-few-arguments-to-function-printk
├── sh-allyesconfig
│   └── net-mac80211-rx.c:error:too-few-arguments-to-function-printk
├── tile-allyesconfig
│   └── net-mac80211-rx.c:error:expected-expression-before-)-token
├── x86_64-allmodconfig
│   ├── include-asm-generic-bug.h:error:expected-expression-before-)-token
│   ├── include-asm-generic-bug.h:note:in-expansion-of-macro-WARN
│   ├── include-asm-generic-bug.h:note:in-expansion-of-macro-__WARN_printf
│   ├── net-mac80211-rx.c:note:in-expansion-of-macro-WARN_ONCE
│   └── net-mac80211-rx.c:sparse:not-enough-arguments-for-function-warn_slowpath_fmt
└── xtensa-allyesconfig
    ├── include-asm-generic-bug.h:error:expected-expression-before-)-token
    ├── include-asm-generic-bug.h:note:in-expansion-of-macro-WARN
    ├── include-asm-generic-bug.h:note:in-expansion-of-macro-__WARN_printf
    └── net-mac80211-rx.c:note:in-expansion-of-macro-WARN_ONCE

elapsed time: 45m

configs tested: 110

i386                     randconfig-a0-201544
blackfin                BF526-EZBRD_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                  TCM-BF537_defconfig
cris                 etrax-100lx_v2_defconfig
arm                           acs5k_defconfig
powerpc                     tqm8560_defconfig
sh                      rts7751r2d1_defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
arm                               allnoconfig
arm                         at91_dt_defconfig
arm                                  at_hdmac
arm                                    ep93xx
arm                       imx_v6_v7_defconfig
arm                                  iop-adma
arm                          marzen_defconfig
arm                          prima2_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                       spear13xx_defconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
i386                             allmodconfig
x86_64               randconfig-x018-11051832
x86_64               randconfig-x019-11051832
x86_64               randconfig-x016-11051832
x86_64               randconfig-x010-11051832
x86_64               randconfig-x012-11051832
x86_64               randconfig-x017-11051832
x86_64               randconfig-x014-11051832
x86_64               randconfig-x013-11051832
x86_64               randconfig-x015-11051832
x86_64               randconfig-x011-11051832
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                     randconfig-s0-201544
i386                     randconfig-s1-201544
x86_64                           allmodconfig
avr32                      atngw100_defconfig
avr32                     atstk1006_defconfig
frv                                 defconfig
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
tile                         tilegx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                                     txx9
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
x86_64                   randconfig-i0-201544
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                     randconfig-i0-201544
i386                     randconfig-i1-201544
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
m32r                       m32104ut_defconfig
m32r                     mappi3.smp_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
xtensa                       common_defconfig
xtensa                          iss_defconfig
i386                               tinyconfig
x86_64                                    lkp
x86_64                                   rhel
i386                     randconfig-n0-201544
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
x86_64               randconfig-x000-11051802
x86_64               randconfig-x009-11051802
x86_64               randconfig-x002-11051802
x86_64               randconfig-x007-11051802
x86_64               randconfig-x001-11051802
x86_64               randconfig-x006-11051802
x86_64               randconfig-x004-11051802
x86_64               randconfig-x003-11051802
x86_64               randconfig-x005-11051802
x86_64               randconfig-x008-11051802
i386                     randconfig-r0-201544
i386                 randconfig-x003-11051803
i386                 randconfig-x009-11051803
i386                 randconfig-x000-11051803
i386                 randconfig-x008-11051803
i386                 randconfig-x001-11051803
i386                 randconfig-x005-11051803
i386                 randconfig-x006-11051803
i386                 randconfig-x007-11051803
i386                 randconfig-x002-11051803
i386                 randconfig-x004-11051803

Thanks,
Fengguang
