Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab1HLAJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 20:09:59 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Bo Nilsson <mr.bonilsson@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Aug 2011 17:09:58 -0700
Subject: RE: ipw2200
Message-ID: <C5A7FB31FD9AEA42B600BDC3C74F8E000C5DB12D@orsmsx511.amr.corp.intel.com> (sfid-20110812_021003_412653_8D5B7EAD)
References: <CAPH1DO2bWghrK5zPquB52bLbLLSDQZ44kuaFjubbVFWEjNteNg@mail.gmail.com>
In-Reply-To: <CAPH1DO2bWghrK5zPquB52bLbLLSDQZ44kuaFjubbVFWEjNteNg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bo,

The device you're referring to is an old Intel device, but no longer supported by Intel. The source is part of the Linux kernel tree, and has not changed by the developers since maintenance on it has stopped.

Also, it appears that a firmware reload occurred with the device. I'm not entirely familiar with this code base, but based on my knowledge of the iwlagn driver, the driver will reload firmware when it encounters several physical layer errors that it cannot recover from. Perhaps the ipw2200 has a similar behaviour.

That said, I have a few questions to ask:

1) what is the result of this firmware reload? 
2) Are you still connected to the AP?
3) Are you able to pass traffic?

Thanks,
Meenakshi

>-----Original Message-----
>From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>owner@vger.kernel.org] On Behalf Of Bo Nilsson
>Sent: Thursday, August 11, 2011 1:16 PM
>To: linux-wireless@vger.kernel.org
>Subject: ipw2200
>
>Is linux braking down? I never had a problem like this before. I will have to go
>back to debian 5 and see if that is stable still.
>
>root@debian:/home/bo# dmesg | grep ipw2200
>[    3.664058] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network
>Driver, 1.2.2kmprq
>[    3.664062] ipw2200: Copyright(c) 2003-2006 Intel Corporation
>[    3.954370] ipw2200 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>[    3.956831] ipw2200: Detected Intel PRO/Wireless 2200BG Network
>Connection
>[    3.956881] ipw2200 0000:02:06.0: firmware: requesting ipw2200-bss.fw
>[    4.590967] ipw2200: Detected geography ZZR (14 802.11bg channels,
>0 802.11a channels)
>[  251.494725] ipw2200: Firmware error detected.  Restarting.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
>body of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
