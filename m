Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34669 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbJSNbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 09:31:03 -0400
Received: by oies66 with SMTP id s66so58213587oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 06:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5624B374.5080209@neratec.com>
References: <CAJ+vNU2q1kLBs8wXRN++62bn24ohthFr=0htDMBh7qxsqmeodg@mail.gmail.com>
	<5624B374.5080209@neratec.com>
Date: Mon, 19 Oct 2015 06:31:01 -0700
Message-ID: <CAJ+vNU2gWU5HcN9oy+T33sN-ufzDKS=_3n0BLM75Pr7=PbHhtw@mail.gmail.com> (sfid-20151019_153110_001556_4BB78060)
Subject: Re: FCC DFS support
From: Tim Harvey <tharvey@gateworks.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 2:10 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 10/16/2015 06:53 PM, Tim Harvey wrote:
>> Greetings,
>>
>> Is FCC DFS support (from the updated rules released in Aug 2014) fully
>> supported in ath10k by the driver/firmware/cards?
>>
>> The linux-wireless DFS page [1] has some great info but doesn't really
>> list what is currently in place and working and doesn't mention ath10k
>> specifically and I didn't see anything on the ath10k page either [2].
>>
>> Thanks for any info!
>>
>> Regards,
>>
>> Tim
>>
>> [1] - https://wireless.wiki.kernel.org/en/developers/dfs
>> [2] - https://wireless.wiki.kernel.org/en/users/drivers/ath10k
>> --
>>
>
> Hi Tim,
>
> you're right, unfortunately the DFS documentation in [1] is quite outdated -
> basically in its initial state from 2011 when ath10k was unknown. It took around
> four years to get the work done, and since numerous parties contributed at
> different times and different modules (driver, mac/cfg, hostapd), the
> documentation has not always been updated accordingly.
>
> But the more important fact is: yes, ath10 and ath9k today fully support FCC.
>
> We certified one of our ath9k based products for FCC and ETSI some months ago, and
> I got confirmations that ath10k also passed certification testing for FCC.
>
> It is relevant to note that both drivers use the same radar pattern detector (and
> all upper layers anyway), so that if ath9k passed, ath10k most probably will also
> do (and vice versa).
>
>
> Hth,
> Zefir
>
>

Zefir,

Thank you for the information!

Tim
