Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43498 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0C3TXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 15:23:25 -0400
Received: by bwz1 with SMTP id 1so4657773bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 12:23:23 -0700 (PDT)
Message-ID: <4BB24FA6.3070508@gmail.com>
Date: Tue, 30 Mar 2010 21:23:18 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, IvDoorn@gmail.com
Subject: Re: [PATCH 4/4] wireless: rt2x00: rt2800usb: new ids
References: <1269799361-12257-1-git-send-email-xose.vazquez@gmail.com> <69e28c911003291504r170c9941u3647f03ad5988b1@mail.gmail.com>
In-Reply-To: <69e28c911003291504r170c9941u3647f03ad5988b1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 12:04 AM, Gábor Stefanik wrote:
> On Sun, Mar 28, 2010 at 8:02 PM, Xose Vazquez Perez

>> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
[...]
>> +       /* Logitec */
>> +       { USB_DEVICE(0x0789, 0x0166), USB_DEVICE_DATA(&rt2800usb_ops) },
> Typo?

NO, deliberate.

RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c says:
{USB_DEVICE(0x0789,0x0166)}, /* Edimax */

but 0x0789 is Logitec, from http://www.linux-usb.org/usb.ids

0789  Logitec Corp.
	0026  LHD Device
	0033  DVD Multi-plus unit LDR-H443SU2
	0063  LDR Device
	0064  LDR-R Device
	00b3  DVD Multi-plus unit LDR-H443U2
	010c  Realtek RTL8187 Wireless 802.11g 54Mbps Network Adapter
	0162  LAN-WN22/U2 Wireless LAN Adapter
	0163  LAN-WN12/U2 Wireless LAN Adapter
	0164  LAN-W150/U2M Wireless LAN Adapter


I believe it's a typo of ralink guys.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
