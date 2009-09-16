Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:58477 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZIPNVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 09:21:17 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1174717fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 06:21:19 -0700 (PDT)
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless 5100 AGN
Date: Wed, 16 Sep 2009 15:21:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909161521.15710.fabio.coatti@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I'm experiencing a bad behaviour of rfkill / iwlang driver. Here the 
description:

Kernels: 2.6.30.[5,6] 2.6.31  
Hardware: HP EliteBook 6930p

Behaviour: once a working wireless is killed activating the rfkill button, 
there is no way to turn off the rfkill and riactivate wifi network. Even a 
reboot is not able to reset the situation; to get again the control of rfkill 
button is to reboot under windows xp and activate wifi. After that I can boot 
inder linux with wifi active and kill it with rfkill button and the loop 
starts again :)
I'm pretty sure that this issue is present since some kernel before the one 
I've reported, but I'm not sure about the versions.

I don't know if this is iwlagn or acpi related bug (or my fault), I'm 
available for any test.

HW:
Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network 
Connection
        Subsystem: Intel Corporation Device 1211                                               
        Flags: bus master, fast devsel, latency 0, IRQ 33                                      
        Memory at d0100000 (64-bit, non-prefetchable) [size=8K]                                
        Capabilities: [c8] Power Management version 3                                          
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+                             
        Capabilities: [e0] Express Endpoint, MSI 00                                            
        Capabilities: [100] Advanced Error Reporting                                           
        Capabilities: [140] Device Serial Number 00-21-6b-ff-ff-74-2b-28                       
        Kernel driver in use: iwlagn                                                           
        Kernel modules: iwlagn 

Let me know if more information are needed.

Thanks for any answer (I'm not subscribed to this list, so please CC me on 
answers, thanks)
