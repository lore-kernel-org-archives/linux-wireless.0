Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52396 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761666AbZAQXbX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 18:31:23 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LOKdL-0006Fm-BA
	for linux-wireless@vger.kernel.org; Sat, 17 Jan 2009 23:31:19 +0000
Received: from 77-21-172-36-dynip.superkabel.de ([77.21.172.36])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 23:31:19 +0000
Received: from feldmann_markus by 77-21-172-36-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 23:31:19 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Does ACPIPHP work on my Machine
Date: Sun, 18 Jan 2009 00:31:11 +0100
Message-ID: <gktpnt$qld$1@ger.gmane.org> (sfid-20090118_003128_532130_CD74783E)
References: <gktp4e$p6h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <gktp4e$p6h$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maybe this is also interesting for you,

wes-nic:/sys/bus/pci/slots# lspci -vt
-[0000:00]-+-00.0  nVidia Corporation nForce3 Host Bridge
            +-01.0  nVidia Corporation nForce3 LPC Bridge
            +-01.1  nVidia Corporation nForce3 SMBus
            +-02.0  nVidia Corporation nForce3 USB 1.1
            +-02.1  nVidia Corporation nForce3 USB 1.1
            +-02.2  nVidia Corporation nForce3 USB 2.0
            +-06.0  nVidia Corporation nForce3 Audio
            +-06.1  nVidia Corporation nForce3 Audio
            +-08.0  nVidia Corporation nForce3 IDE
            +-0a.0-[0000:02-0a]--+-00.0  Texas Instruments TSB43AB21 
IEEE-1394a-2000 Controller (PHY/Link)
            |                    +-01.0  Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+
            |                    +-02.0  Broadcom Corporation BCM4303 
802.11b Wireless LAN Controller
            |                    +-04.0  Texas Instruments PCI1620 PC 
Card Controller
            |                    +-04.1  Texas Instruments PCI1620 PC 
Card Controller
            |                    \-04.2  Texas Instruments PCI1620 
Firmware Loading Function
            +-0b.0-[0000:01]----00.0  nVidia Corporation NV17 [GeForce4 
440 Go 64M]
            +-18.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
            +-18.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
            +-18.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
            \-18.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control

Regards Markus

