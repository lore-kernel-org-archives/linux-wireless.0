Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57074 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab1L0Rkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 12:40:46 -0500
Received: by iaeh11 with SMTP id h11so20680347iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2011 09:40:45 -0800 (PST)
Message-ID: <4EFA0319.2030505@lwfinger.net> (sfid-20111227_184053_239611_4ABC1E6A)
Date: Tue, 27 Dec 2011 11:40:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, helmut.schaa@googlemail.com,
	IvDoorn@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800usb: Move ID out of unknown
References: <4ef9f8d7.gS21SIcvWuSTbCy9%Larry.Finger@lwfinger.net> <4EFA00DC.8070007@gmail.com>
In-Reply-To: <4EFA00DC.8070007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2011 11:31 AM, Gertjan van Wingerde wrote:
> Hi Larry,
>
> On 12/27/11 17:56, Larry Finger wrote:
>> Testing on the openSUSE wireless forum has shown that a Linksys
>> WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
>> written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> Cc: Stable<stable@vger.kernel.org>
>
> We've got these devices is the UNKNOWN section because we don't know
> what chipset is used by these devices (and therefore the level of
> support is unknown).
>
> Do you know which chipset is used by this device?
>
> This should be reported in dmesg when CONFIG_RT2X00_DEBUG is enabled.

The OP is using an openSUSE distro kernel so we don't have the chance to get 
info from that source. With lsusb, we get Bus 001 Device 002: ID 1737:0077 
Linksys WUSB54GC v3 802.11g Adapter [Ralink RT2070L]. Does that help?

I just ordered one of these devices from E-bay. I can get you more info when it 
arrives.

Larry


