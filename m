Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:51330 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbZKWXy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 18:54:27 -0500
Received: by bwz23 with SMTP id 23so5840043bwz.29
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 15:54:33 -0800 (PST)
Subject: RE: [ipw3945-devel] iwl3945 dies on module reload
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B4E6032E5@orsmsx502.amr.corp.intel.com>
References: <1258968499.3271.5.camel@maxim-laptop>
	 <1258972050.7094.140.camel@johannes.local>
	 <1258973082.3675.0.camel@maxim-laptop>
	 <1258973362.7094.151.camel@johannes.local>
	 <1258996575.9727.2.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B4E6032E5@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 01:54:28 +0200
Message-ID: <1259020468.16650.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-23 at 15:24 -0800, Cahill, Ben M wrote: 
> 
> >-----Original Message-----
> >From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
> >Sent: Monday, November 23, 2009 12:16 PM
> >To: Johannes Berg
> >Cc: linux-wireless; iwlwifi maling list
> >Subject: [ipw3945-devel] iwl3945 dies on module reload
> >
> >When reloading the iwl3945 driver I often get this:
> >
> >
> >[  830.333386] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG 
> >Network Connection driver for Linux, 1.2.26kds
> >[  830.333407] iwl3945: Copyright(c) 2003-2009 Intel Corporation
> >[  830.333536] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 
> >(level, low) -> IRQ 19
> >[  830.374979] iwl3945 0000:06:00.0: Tunable channels: 13 
> >802.11bg, 0 802.11a channels
> >[  830.374995] iwl3945 0000:06:00.0: Detected Intel Wireless 
> >WiFi Link 3945BG
> >[  830.375163] iwl3945 0000:06:00.0: irq 32 for MSI/MSI-X
> >[  830.376859] phy0: Selected rate control algorithm 'iwl-3945-rs'
> >[  830.427214] iwl3945 0000:06:00.0: firmware: requesting 
> >iwlwifi-3945-2.ucode
> >[  830.526945] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
> >[  830.544236] CE: hpet increasing min_delta_ns to 15000 nsec
> >[  830.575694] iwl3945 0000:06:00.0: BSM uCode verification 
> >failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020
> >[  830.578862] iwl3945 0000:06:00.0: Hardware error detected.  
> >Restarting.
> >[  832.570133] iwl3945 0000:06:00.0: Wait for START_ALIVE 
> >timeout after 2000ms.
> >[  832.622676] iwl3945 0000:06:00.0: BSM uCode verification 
> >failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020
> >[  832.625839] iwl3945 0000:06:00.0: Hardware error detected.  
> >Restarting.
> >[  834.620132] iwl3945 0000:06:00.0: Wait for START_ALIVE 
> >timeout after 2000ms.
> 
> The 0xa5a5a5a2 signature indicates that the device is powered up and the PCI Express link is working, but somehow the device internals have not been powered up / initialized.
> 
> Are you using a very recent version of the driver?  I've done some work in this area in the past couple of months.


I use -git tip of wireless-testing

Best regards,
Maxim Levitsky

