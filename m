Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:56275 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaLQNOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:14:07 -0500
Message-ID: <5491819C.2050303@broadcom.com> (sfid-20141217_141411_490832_CF181839)
Date: Wed, 17 Dec 2014 14:14:04 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@thinktube.com>
CC: Dani Camps <danicamps81@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: mac80211 USB adapters with 5GHz support and SMA antenna
References: <CAD3NH5X-neqP-61kP=C2oNPPJTQNBkarae0rh93Hm4qzdpZRew@mail.gmail.com> <54916C38.80103@thinktube.com>
In-Reply-To: <54916C38.80103@thinktube.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/14 12:42, Bruno Randolf wrote:
> Hi,
>
> On 12/16/2014 07:09 PM, Dani Camps wrote:
>> I am looking for a Wi-Fi adapter with the following specs:
>>
>> a) Operates at 5GHz
>> b) Supports 802.11n and optionally 802.11ac
>> c) USB interface
>> d) SMA connector for external antenna(s)
>> e) It is supported by mac80211, and supports mesh mode
>
> Me too...
>
> IHMO the best USB based chipset/driver combination is still ath9k_htc
> with Atheros AR7010/AR9280 or AR9271, which is rock solid and has very
> good thruput (and an open firmware). Unfortunately I have heard it's EOL
> but it's still possible to buy them, e.g the "TP-Link TL-WN722N" or
> "TP-LINK TL-WN822N"...
>
> I have not found good alternatives yet... So I repeat: Does anyone know
> a good USB dongle with a good mac/cfg80211 driver and at least 802.11n
> 2x2:2 and support for AP and IBSS mode?
>
> It's a shame that vendors like Ralink/MediaTek and Realtek do not work
> on decent upstream linux drivers... Instead of wasting time cleaning up
> the mess they leave with dozens of incomplete "vendor drivers" they drop
> on us - maybe the Linux community should just choose *ONE* modern
> (preferrably "ac") and cheap USB chipset and concentrate on writing a
> driver for it?
>
> And what about the vendors which are more involved in proper linux
> wireless develpment? Qualcom/Atheros, Intel, Broadcom: don't you have
> any USB chipsets in line?

We do, but no mac80211-based USB devices.

Regards,
Arend

> bruno
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

