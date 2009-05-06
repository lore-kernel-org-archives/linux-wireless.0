Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s19.blu0.hotmail.com ([65.55.111.94]:2059 "EHLO
	blu0-omc2-s19.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760500AbZEFRKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 13:10:32 -0400
Message-ID: <BLU0-SMTP927233387EF28700A274AFC2660@phx.gbl>
Date: Wed, 06 May 2009 12:10:27 -0500
From: Brett Ussher <breusshe@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: make clean does not work for compat-wireless-2009-05-06
Content-Type: multipart/mixed;
 boundary="------------010400000507030401080607"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010400000507030401080607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Just tried to "make clean" the source folder for compat-wireless.  Fails 
with error 2.  File attached with debug output (output.txt) and errors 
to screen (screen.txt).

-- 
Brett D. Ussher


--------------010400000507030401080607
Content-Type: text/plain;
 name="output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.txt"

GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `Makefile'...
Reading makefile `/usr/src/linux-headers-2.6.27-11-generic/scripts/Kbuild.include' (search path) (no ~ expansion)...
Reading makefile `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile' (search path) (no ~ expansion)...
Reading makefile `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu'.
  Looking for an implicit rule for `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.o'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cc'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.C'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cpp'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.p'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.f'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.s'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.mod'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.sh'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.o'.
  Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.o'.
   Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cc'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.C'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cpp'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.p'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.f'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.s'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.mod'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.y'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.l'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.w'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.y'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.y'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.l'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.l'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.w'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.w'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cc'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cc'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.C'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.C'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cpp'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cpp'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.p'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.p'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.web'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.web'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.web'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.f'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.f'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Trying pattern rule with stem `Makefile_32.cpu'.
     Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.l'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.s'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.s'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
    Trying pattern rule with stem `Makefile_32.cpu'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
   Trying pattern rule with stem `Makefile_32.cpu'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.mod'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.mod'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.c'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cc'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.C'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.cpp'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.p'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.f'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.F'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.r'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.s'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.S'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.mod'.
  Trying pattern rule with stem `Makefile_32.cpu'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.sh'.
  Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu.sh'.
   Avoiding implicit rule recursion.
  No implicit rule found for `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu'.
  Finished prerequisites of target file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu'.
 No need to remake target `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile_32.cpu'.
 Considering target file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile'.
  Looking for an implicit rule for `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.o'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cc'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.C'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cpp'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.p'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.f'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.s'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.mod'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.sh'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.o'.
  Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.o'.
   Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cc'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.C'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cpp'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.p'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.f'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.s'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.mod'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.y'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.l'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.w'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.y'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.y'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.l'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.l'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.w'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.w'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cc'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cc'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.C'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.C'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cpp'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cpp'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.p'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.p'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.web'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.web'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.web'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.f'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.f'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
    Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Avoiding implicit rule recursion.
     Trying pattern rule with stem `Makefile'.
     Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.l'.
   Trying pattern rule with stem `Makefile'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
   Trying pattern rule with stem `Makefile'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.s'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.s'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
    Trying pattern rule with stem `Makefile'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
    Trying pattern rule with stem `Makefile'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
    Trying pattern rule with stem `Makefile'.
    Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
   Trying pattern rule with stem `Makefile'.
   Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
   Trying pattern rule with stem `Makefile'.
   Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.mod'.
   Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.mod'.
    Avoiding implicit rule recursion.
    Avoiding implicit rule recursion.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.c'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cc'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.C'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.cpp'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.p'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.f'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.F'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.r'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.s'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.S'.
  Trying pattern rule with stem `Makefile'.
  Rejecting impossible implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.mod'.
  Trying pattern rule with stem `Makefile'.
  Trying implicit prerequisite `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.sh'.
  Looking for a rule with intermediate file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile.sh'.
   Avoiding implicit rule recursion.
  No implicit rule found for `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile'.
  Finished prerequisites of target file `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile'.
 No need to remake target `/usr/src/linux-headers-2.6.27-11-generic/arch/x86/Makefile'.
 Considering target file `/usr/src/linux-headers-2.6.27-11-generic/scripts/Kbuild.include'.
  Finished prerequisites of target file `/usr/src/linux-headers-2.6.27-11-generic/scripts/Kbuild.include'.
 No need to remake target `/usr/src/linux-headers-2.6.27-11-generic/scripts/Kbuild.include'.
 Considering target file `Makefile'.
  Finished prerequisites of target file `Makefile'.
 No need to remake target `Makefile'.
Updating goal targets....
Considering target file `clean'.
 File `clean' does not exist.
  Considering target file `_clean_/home/brett/Desktop/compat-wireless-2009-05-06'.
   File `_clean_/home/brett/Desktop/compat-wireless-2009-05-06' does not exist.
   Finished prerequisites of target file `_clean_/home/brett/Desktop/compat-wireless-2009-05-06'.
  Must remake target `_clean_/home/brett/Desktop/compat-wireless-2009-05-06'.
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-11-generic'
Putting child 0x090e7b08 (_clean_/home/brett/Desktop/compat-wireless-2009-05-06) PID 24261 on the chain.
Live child 0x090e7b08 (_clean_/home/brett/Desktop/compat-wireless-2009-05-06) PID 24261 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile' (search path) (no ~ expansion)...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk' (search path) (no ~ expansion)...
Reading makefile `/lib/modules/2.6.27-11-generic/build/.config' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/lib/modules/2.6.27-11-generic/build/.config'.
  Looking for an implicit rule for `/lib/modules/2.6.27-11-generic/build/.config'.
  No implicit rule found for `/lib/modules/2.6.27-11-generic/build/.config'.
  Finished prerequisites of target file `/lib/modules/2.6.27-11-generic/build/.config'.
 No need to remake target `/lib/modules/2.6.27-11-generic/build/.config'.
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/config.mk'.
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom'.
Putting child 0x09072848 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom) PID 24800 on the chain.
Live child 0x09072848 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom) PID 24800 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x09072848 PID 24800 
Removing child 0x09072848 PID 24800 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/misc/eeprom'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb'.
Putting child 0x09072890 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb) PID 24910 on the chain.
Live child 0x09072890 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb) PID 24910 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x09072890 PID 24910 
Removing child 0x09072890 PID 24910 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/usb'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless'.
Putting child 0x09071cd8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless) PID 25023 on the chain.
Live child 0x09071cd8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless) PID 25023 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath'.
Putting child 0x084ed230 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath) PID 25024 on the chain.
Live child 0x084ed230 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath) PID 25024 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170'.
Putting child 0x0868c080 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170) PID 25025 on the chain.
Live child 0x0868c080 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170) PID 25025 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x0868c080 PID 25025 
Removing child 0x0868c080 PID 25025 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ar9170'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k'.
Putting child 0x0868c3a8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k) PID 25026 on the chain.
Live child 0x0868c3a8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k) PID 25026 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x0868c3a8 PID 25026 
Removing child 0x0868c3a8 PID 25026 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath5k'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k'.
Putting child 0x0868c6d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k) PID 25027 on the chain.
Live child 0x0868c6d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k) PID 25027 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x0868c6d0 PID 25027 
Removing child 0x0868c6d0 PID 25027 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath/ath9k'.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x084ed230 PID 25024 
Removing child 0x084ed230 PID 25024 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ath'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43'.
Putting child 0x084ef1d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43) PID 25028 on the chain.
Live child 0x084ef1d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43) PID 25028 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x084ef1d0 PID 25028 
Removing child 0x084ef1d0 PID 25028 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy'.
Putting child 0x08506518 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy) PID 25029 on the chain.
Live child 0x08506518 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy) PID 25029 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x08506518 PID 25029 
Removing child 0x08506518 PID 25029 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/b43legacy'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00'.
Putting child 0x0850ddb8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00) PID 25030 on the chain.
Live child 0x0850ddb8 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00) PID 25030 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x0850ddb8 PID 25030 
Removing child 0x0850ddb8 PID 25030 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/ipw2x00'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi'.
Putting child 0x084feda0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi) PID 25031 on the chain.
Live child 0x084feda0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi) PID 25031 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x084feda0 PID 25031 
Removing child 0x084feda0 PID 25031 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/iwlwifi'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas'.
Putting child 0x08506f50 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas) PID 25032 on the chain.
Live child 0x08506f50 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas) PID 25032 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x08506f50 PID 25032 
Removing child 0x08506f50 PID 25032 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf'.
Putting child 0x08503460 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf) PID 25033 on the chain.
Live child 0x08503460 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf) PID 25033 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x08503460 PID 25033 
Removing child 0x08503460 PID 25033 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/libertas_tf'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54'.
Putting child 0x08503470 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54) PID 25034 on the chain.
Live child 0x08503470 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54) PID 25034 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x08503470 PID 25034 
Removing child 0x08503470 PID 25034 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/p54'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00'.
Putting child 0x085034b0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00) PID 25035 on the chain.
Live child 0x085034b0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00) PID 25035 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x085034b0 PID 25035 
Removing child 0x085034b0 PID 25035 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rt2x00'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x'.
Putting child 0x085084d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x) PID 25036 on the chain.
Live child 0x085084d0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x) PID 25036 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile'.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile'.
 No need to remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x/Makefile'.
 Considering target file `scripts/Makefile.clean'.
  Looking for an implicit rule for `scripts/Makefile.clean'.
  No implicit rule found for `scripts/Makefile.clean'.
  Finished prerequisites of target file `scripts/Makefile.clean'.
 No need to remake target `scripts/Makefile.clean'.
Updating goal targets....
Considering target file `__clean'.
 File `__clean' does not exist.
 Finished prerequisites of target file `__clean'.
Must remake target `__clean'.
Successfully remade target file `__clean'.
Reaping winning child 0x085084d0 PID 25036 
Removing child 0x085084d0 PID 25036 from chain.
  Successfully remade target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/rtl818x'.
  Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx'.
   File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx' does not exist.
   Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx'.
  Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx'.
Putting child 0x08512db0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx) PID 25037 on the chain.
Live child 0x08512db0 (/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx) PID 25037 
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i486-pc-linux-gnu
Reading makefiles...
Reading makefile `scripts/Makefile.clean'...
Reading makefile `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile' (search path) (no ~ expansion)...
Updating makefiles....
 Considering target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.
  File `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile' does not exist.
  Looking for an implicit rule for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.
  No implicit rule found for `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.
  Finished prerequisites of target file `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.
 Must remake target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.
Reaping losing child 0x08512db0 PID 25037 
Removing child 0x08512db0 PID 25037 from chain.
Reaping losing child 0x09071cd8 PID 25023 
Removing child 0x09071cd8 PID 25023 from chain.
Reaping losing child 0x090e7b08 PID 24261 
Removing child 0x090e7b08 PID 24261 from chain.
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-11-generic'

--------------010400000507030401080607
Content-Type: text/plain;
 name="screen.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="screen.txt"

brett@Ussher--Laptop ~/Desktop/compat-wireless-2009-05-06 $ make clean
gedit output.txtscripts/Makefile.clean:17: /home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile: No such file or directory
make[4]: *** No rule to make target `/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx/Makefile'.  Stop.
make[3]: *** [/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless/wl12xx] Error 2
make[2]: *** [/home/brett/Desktop/compat-wireless-2009-05-06/drivers/net/wireless] Error 2
make[1]: *** [_clean_/home/brett/Desktop/compat-wireless-2009-05-06] Error 2
make: *** [clean] Error 2

--------------010400000507030401080607--
