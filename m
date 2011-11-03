Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61685 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046Ab1KCQ6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 12:58:25 -0400
Received: by wwf22 with SMTP id 22so930861wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 09:58:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EB2C516.1020703@neratec.com>
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>
	<1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com>
	<CAD2nsn2SBVnQF4oTP4X3HR7O=uBKAViW+w-fV67YjbVN1j=3PQ@mail.gmail.com>
	<4EB2C516.1020703@neratec.com>
Date: Thu, 3 Nov 2011 22:27:25 +0530
Message-ID: <CAD2nsn0Qh722tt4NCaMit27XL+uPNsXnxk8tqddoBaK9dA8pXQ@mail.gmail.com> (sfid-20111103_175828_902399_86306398)
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 3, 2011 at 10:15 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 11/03/2011 04:27 PM, Mohammed Shafi wrote:
>> Hi Zefir,
>>
> Hello Mohammed,
>
>> On Thu, Nov 3, 2011 at 7:25 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>> [...]
>>>
>>> +       if (ah->caps.hw_caps && ATH9K_HW_CAP_DFS) {
>>> +               /**
>>> +                * enable radar pulse detection
>>> +                *
>>> +                * TODO: do this only for DFS channels
>>> +                */
>>> +               ah->private_ops.set_radar_params(ah, &ah->radar_conf);
>>
>> can we do this something like ath9k_hw_set_radar_params?
>> why we need a seperate debug file for dfs, had i missed something?
>>
> My first proposal included the DFS statistics in debug.c, but Luis asked me to keep it separated (see http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg06821.html). I'm fine with both approaches, just let me know.

oh ok. please follow up with Luis's approach. thanks.

>
> I'll add a ath9k_hw_set_radar_params() in v3.
>
>
> Thanks,
> Zefir
>



-- 
shafi
