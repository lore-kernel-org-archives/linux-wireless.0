Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45936 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbZAIKus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 05:50:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Fwd: [b43] opensource firmware
Date: Fri, 9 Jan 2009 11:49:28 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	David Woodhouse <dwmw2@infradead.org>
References: <200901091129.22708.mb@bu3sch.de>
In-Reply-To: <200901091129.22708.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200901091149.28683.mb@bu3sch.de> (sfid-20090109_115101_329910_6DE80E0F)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd like to start merging this into the "firmware" directory
of the mainline kernel.

On Friday 09 January 2009 11:29:22 Michael Buesch wrote:
> 
> ----------  Forwarded Message  ----------
> 
> Subject: opensource firmware
> Date: Friday 09 January 2009
> From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
> To: bcm43xx-dev@lists.berlios.de
> 
> Hello folks,
> 
> we have been involved in the past few months in testing modifications  
> to the standard 802.11 MAC for research purposes. During this time we  
> did some tests with Broadcom 802.11b/g boards and we wrote down a  
> simple 802.11 compliant firmware that we used as a starting point for  
> the modified MAC algorithms.
> 
> Although the base firmware is not fully 802.11 compliant, e.g., it  
> does not support RTS/CTS procedure or QoS, we believe that someone  
> could be interested in testing it. The firmware does not require the  
> kernel to be modified and it uses the same shared memory layout and  
> global registers usage of the original stuff from broadcom to ease  
> loading by the b43 driver (and ease our writing...). We wrote it to  
> make the b43 driver recognize it as Broadcom version 5 firmware: it  
> still uses the original initval files of that version of the  
> Broadcom's firmware, we do not include them as usual users have to  
> extract these files following the b43 installation instructions.
> 
> Lorenzo and I tested this firmware only on 4306 and 4318 hardware (pci  
> and minipci, pc-card based architectures seem to have problems), and  
> we did simple tests on the integrated board of a Linksys WRT54GL, so  
> we are quite sure it runs on 4306, 4318 and 4320 cards. We did all the  
> works on kernel 2.6.27-rc5-wl.
> 
> The firmware along with the instructions to build it from the assembly  
> code using the tools developed by the b43 community can be found here
> 
> 	http://www.ing.unibs.it/openfwwf
> 
> In the firmware website you can find more information about the fw  
> algorithm, its interaction with Broadcom hardware and other  
> information that we discovered as we were writing it.
> 
> We would like to underline that this work would have not been possible  
> without the instruments already developed by the b43 community  
> (assembler/disassembler), hardware specifications (sipsolution's  
> website), the opensource test firmware written by Michael Buesch and  
> useful talks with those guys (b43 developers), which we deeply  
> acknowledge. As we used several definition files written by Michael  
> for its firmware and we have prepared a source tar file that includes  
> them, we kindly ask Michael if this could be a problem.
> 
> Finally we stress that this is a TEST firmware and some stuff needs to  
> be fixed (e.g. RTS/CTS and QoS), we have been using it as a starting  
> point to implement other MAC algorithms for research purposes: if  
> someone is interested in this kind of work and would like to share  
> ideas also on research topics, please let us know.
> 
> Cheers,
> Francesco Gringoli
> Lorenzo Nava
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> 
> 
> -------------------------------------------------------
> 



-- 
Greetings, Michael.
