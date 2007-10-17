Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:36903 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753727AbXJQOId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:08:33 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: iwl3945 doesn't work
Date: Wed, 17 Oct 2007 17:08:48 +0300
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <20071017135452.GJ5043@kernel.dk>
In-Reply-To: <20071017135452.GJ5043@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200710171708.48654.ismail@pardus.org.tr> (sfid-20071017_150837_183502_1B704061)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wednesday 17 October 2007 Tarihinde 16:54:53 yazm=C4=B1=C5=9Ft=C4=B1:
> Hi,
>
> Seeing that iwl3945 is now merged, I decided to switch my x60 to use
> that instead of ipw3945. That would leave me with zero kernel
> dependencies.
>
> Unfortunately it doesn't work. Loading the module reveals the device:
>
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver f=
or
> Linux, 1.1.17ks
> iwl3945: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> phy0: Selected rate control algorithm 'iwl-3945-rs'
>
> # iwconfig wlan0
> wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"
>           Mode:Managed  Channel:0  Access Point: Not-Associated
>           Tx-Power=3D0 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B
>           Encryption key:XXXX-XXXX-XX
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> and iwconfig sees it, essid/enc settings are fine, but I don't get a
> link.

Same issue here, try iwlist wlan0 scan first and then it should work.

Regards,
ismail

--=20
=46aith is believing what you know isn't so -- Mark Twain
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
