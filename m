Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluehome.net ([96.66.250.149]:47628 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbeBITuZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 14:50:25 -0500
From: jason@bluehome.net
To: linux-wireless@vger.kernel.org
Cc: Jason Self <j@jxself.org>
Subject: [PATCH] carl9170: Download from ftpmirror.gnu.org
Date: Fri,  9 Feb 2018 11:50:23 -0800
Message-Id: <1518205823-14511-1-git-send-email-jason@bluehome.net> (sfid-20180209_205028_815561_CF3F49EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Self <j@jxself.org>

binutils and GCC should be downloaded from the mirror redirector.
mirrors.kernel.org is just one of many GNU mirrors. Using their
redirector takes advantage of all the mirrors that exist. MPFR, GMP
and MPC in this Makefile already do this. It's good to be consistent.

Signed-off-by: Jason Self <j@jxself.org>
---
 toolchain/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/toolchain/Makefile b/toolchain/Makefile
index c12bfae..622db5f 100644
--- a/toolchain/Makefile
+++ b/toolchain/Makefile
@@ -1,6 +1,6 @@
 BINUTILS_VER=2.29.1
 BINUTILS_TAR=binutils-$(BINUTILS_VER).tar.xz
-BINUTILS_URL="http://mirrors.kernel.org/gnu/binutils/$(BINUTILS_TAR)"
+BINUTILS_URL="http://ftpmirror.gnu.org/gnu/binutils/$(BINUTILS_TAR)"
 
 NEWLIB_VER=3.0.0
 NEWLIB_TAR=newlib-$(NEWLIB_VER).tar.gz
@@ -8,7 +8,7 @@ NEWLIB_URL="ftp://sourceware.org/pub/newlib/$(NEWLIB_TAR)"
 
 GCC_VER=7.3.0
 GCC_TAR=gcc-$(GCC_VER).tar.xz
-GCC_URL="http://mirrors.kernel.org/gnu/gcc/gcc-$(GCC_VER)/$(GCC_TAR)"
+GCC_URL="http://ftpmirror.nu.org/gnu/gcc/gcc-$(GCC_VER)/$(GCC_TAR)"
 
 MPFR_VER=4.0.0
 MPFR_TAR=mpfr-$(MPFR_VER).tar.xz
-- 
1.9.1
