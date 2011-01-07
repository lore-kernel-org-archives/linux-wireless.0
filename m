Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab1AGCAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:00:40 -0500
Received: by iyi12 with SMTP id 12so15404535iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:00:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTintPXzmiGnjEQvXUO3hVCW9J4tGn=MookTx1qBM@mail.gmail.com>
References: <19749.32067.311517.479374@gargle.gargle.HOWL> <19749.37051.292861.996698@gargle.gargle.HOWL>
 <19750.24410.495583.789895@gargle.gargle.HOWL> <AANLkTintPXzmiGnjEQvXUO3hVCW9J4tGn=MookTx1qBM@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 6 Jan 2011 18:00:20 -0800
Message-ID: <AANLkTi=ZcigYLqqmhHc638_AxSODWrVrTV5KELRws3XX@mail.gmail.com>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 4:56 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 4:33 PM, Sujith <m.sujith@gmail.com> wrote:
>> (Resend to list).
>>
>> Sujith wrote:
>>> Sujith wrote:
>>> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>>> >
>>> > Add two new per-BSS attributes to allow configuration of
>>> > HT capabilites and operational parameters by hostapd.
>>>
>>> Ok, looks like this is not needed after all.
>>> When operating in AP mode, an associated station's HT caps is
>>> notified to the driver through sta_add() anyway.
>>>
>>> The main motive for this patch was that ath9k_htc required the
>>> HT params of the current BSS and it turns out that the firmware
>>> doesn't do anything with the information. :)
>
> Ah, I thought the purpose was to allow dynamic configuration of HT
> capa/params used.
>

Yeah, me too.  Isn't greenfield mode (whether there are legacy devices
around) part of the operating capabilities and should be supported by
hostapd?

Dan
