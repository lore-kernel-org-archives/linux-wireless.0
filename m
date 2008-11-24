Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:20136 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKXXaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:30:16 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1938837rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 15:30:15 -0800 (PST)
Message-ID: <43e72e890811241530t44245e4ar3fd5797afcc451c0@mail.gmail.com> (sfid-20081125_003021_840688_73B4CF46)
Date: Mon, 24 Nov 2008 15:30:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Richard Farina" <sidhayn@gmail.com>
Subject: Re: wireless-regdb: update regulatory rules for US 2.3-2.4GHz and 5.65-5.925GHz
Cc: "John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Michael Green" <Michael.Green@atheros.com>
In-Reply-To: <492B3643.4070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <492B2E07.9050105@gmail.com> <20081124230427.GM6245@tesla>
	 <492B3643.4070904@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 3:18 PM, Richard Farina <sidhayn@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Mon, Nov 24, 2008 at 02:43:19PM -0800, Richard Farina wrote:
>>
>>>
>>> The above frequencies are allowed by FCC part 97 to amateur radio
>>> operator as primary use, this doesn't even cover the secondary and
>>> tertiary uses, just where amateurs are primary.
>>>
>>
>> NACK -- For the US we use the wireless regulatory database for Part 15
>> rules with 802.11 in mind.
>>
>>
>
> Not only do I understand your reasoning, but I also agree.  Please do
> consider the following (from that same email):

Thanks :)

> This also introduces a new issue in crda of setting not only power limits
> but power limits based on modulation.  It is permitted to use DSSS up to 100
> watts, however, OFDM is permitted up to 1500 watts.
>
> Would it be an unreasonable request to have crda support modulation
> restrictions and power limit based on modulation restrictions?

This is odd, first time I hear about such a thing. Do you have a
pointer to Part 15 rules which clarifies this?

  Luis
