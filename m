Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38511 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZHUMNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:13:19 -0400
Received: by ewy3 with SMTP id 3so585162ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 05:13:19 -0700 (PDT)
Message-Id: <55FEAD01-712B-4165-9F4D-260BDC3CA14A@envitel.com>
From: Miguel Garcia-Lopez <mgarcia@envitel.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Subject: USB wireless support for ARM device and old kernel version
Mime-Version: 1.0 (Apple Message framework v936)
Date: Fri, 21 Aug 2009 14:12:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

We are developing an embedded linux platform using an ARM-based micro  
and other DSPs from Texas Instruments. Among other things, it supports  
USB.

We now need to add a wifi interface to the device, so we're thinking  
on using a USB wireless device. Now, the problem seems to be re are  
running a 2.6.10 kernel and most of the suff/drivers I found require  
much recent versions to work with.

I'm thinking on trying to compile the source code for some driver(s)  
against our kernel sources, but could not really find any working  
sources since most available driver code and wireless infraestructure  
seems to either be already merged into more recent versions of the  
kernel, or require it for compiling.

Any hints on what to try or driver sources distributions I could try  
to compile against my 2.6.10 kernel?

Thanks in advance!

--
Miguel García López
Director Técnico
Technical Manager
.......................................................
E N V I T E L
Parque Científico de Madrid - Local 105
PTM - C/Santiago Grisolía, 2
28760 Tres Cantos - Madrid - Spain
T: +34 91 334 06 56
F: +34 91 358 52 36
M: +34 649 91 60 60
.......................................
mgarcia@envitel.com
www.envitel.com





