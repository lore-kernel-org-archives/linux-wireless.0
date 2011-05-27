Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1E0Itc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 04:49:32 -0400
Received: by wwa36 with SMTP id 36so1624417wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 01:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=0wo+io1LjUwP-Rgy5qH=Qv+v_nw@mail.gmail.com>
References: <24ECC725-EA49-48CA-8B9D-FDD71BD257A0@cs.washington.edu>
	<BANLkTi=Hxaj+mDm5Ecqut2hxefNHyuO8-Q@mail.gmail.com>
	<BANLkTi=3mGWzGghuip2xyo+24yd2mJXfUg@mail.gmail.com>
	<BANLkTimgLTw2A27qtfHPdM3-tKf29xFGVw@mail.gmail.com>
	<BANLkTi=0wo+io1LjUwP-Rgy5qH=Qv+v_nw@mail.gmail.com>
Date: Fri, 27 May 2011 14:19:31 +0530
Message-ID: <BANLkTikuKy6y0dcWDx4ar=ftQY5GbWFy2w@mail.gmail.com> (sfid-20110527_104936_475536_AE8C66A4)
Subject: Re: [PATCH/RFC] ath9k: fix two more bugs in tx power
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable@kernel.org, blaise@willowgarage.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 27, 2011 at 1:36 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 27 May 2011 15:58, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> yes, but I am not sure whether this configuration from eeprom is
>> needed for AR9003?
>> if they are hardcoding the data from eeprom may return 0 ?
>
> No idea, I don't know the AR9003 code yet. :)
>
>> hmmm in ath9k not exactly the same is there,
>>   REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
>>                  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
>>                  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
>
> Hm, I'm not sure what that's for. Is it for per-packet TPC?

yes
quoting the descritption:
subtract this value  in dBm (0.5dB steps) from  per_packet_powertx_max
 when  3 /2 chains are active

>
>
>
> Adrian
>



-- 
shafi
