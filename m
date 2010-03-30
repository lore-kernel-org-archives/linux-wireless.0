Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53884 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0C3Snv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:43:51 -0400
Received: by bwz1 with SMTP id 1so4628030bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 11:43:50 -0700 (PDT)
Message-ID: <4BB24655.5040908@gmail.com>
Date: Tue, 30 Mar 2010 20:43:33 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW RT307x/RT309x
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Correia wrote:

> I'm sorry to be kinda annoying, but the firmware cannot be distributed
> unless it is available directly from Ralink's website with a proper
> license.
> 
> Therefore I kindly request that nothing should be done about this request.
> 
> I will personally contact Ralink and ask for the relevant firmware
> files to be made available.

FW files are inside the source code of the drivers:

./pci/2010_0115_RT3562_RT3062_Linux_STA_V2.3.0.0/include/firmware.h
./pci/2010_01_29_RT2860_Linux_STA_v2.3.0.0/include/firmware.h
./pci/RT3090_LinuxSTA_V2.3.1.4_20100222/include/firmware.h
./usb/2009_1214_RT3572_LinuxSTA_V2.3.0.0/include/firmware.h
./usb/RT2870_LinuxSTA_V2.3.0.0/include/firmware.h
./usb/RT3070_LinuxSTA_V2.3.0.1_20100208/include/firmware.h

License:

/*
 Copyright (c) 2007, Ralink Technology Corporation 
 All rights reserved. 

 Redistribution.  Redistribution and use in binary form, without 
 modification, are permitted provided that the following conditions are 
 met: 

 	* Redistributions must reproduce the above copyright notice and the 
 	following disclaimer in the documentation and/or other materials 
 	provided with the distribution. 
 	* Neither the name of Ralink Technology Corporation nor the names of its 
 	suppliers may be used to endorse or promote products derived from this 
 	software without specific prior written permission. 
 	* No reverse engineering, decompilation, or disassembly of this software 
 	is permitted. 

 Limited patent license. Ralink Technology Corporation grants a world-wide, 
 royalty-free, non-exclusive license under patents it now or hereafter 
 owns or controls to make, have made, use, import, offer to sell and 
 sell ("Utilize") this software, but solely to the extent that any 
 such patent is necessary to Utilize the software alone, or in 
 combination with an operating system licensed under an approved Open 
 Source license as listed by the Open Source Initiative at 
 http://opensource.org/licenses.  The patent license shall not apply to 
 any other combinations which include this software.  No hardware per 
 se is licensed hereunder. 

 DISCLAIMER.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
 COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
 TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
 DAMAGE. 
*/ 

Even with this license Fedora, ... etc are able to distribute them.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
