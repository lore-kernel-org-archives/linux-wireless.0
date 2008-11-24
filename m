Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:24668 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYKXXS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:18:28 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1189172nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 15:18:26 -0800 (PST)
Message-ID: <492B3643.4070904@gmail.com> (sfid-20081125_001833_172068_AC887174)
Date: Mon, 24 Nov 2008 18:18:27 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: update regulatory rules for US 2.3-2.4GHz and
 5.65-5.925GHz
References: <492B2E07.9050105@gmail.com> <20081124230427.GM6245@tesla>
In-Reply-To: <20081124230427.GM6245@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Nov 24, 2008 at 02:43:19PM -0800, Richard Farina wrote:
>   
>> The above frequencies are allowed by FCC part 97 to amateur radio
>> operator as primary use, this doesn't even cover the secondary and
>> tertiary uses, just where amateurs are primary.
>>     
>
> NACK -- For the US we use the wireless regulatory database for Part 15
> rules with 802.11 in mind.
>
>   
Not only do I understand your reasoning, but I also agree.  Please do 
consider the following (from that same email):

This also introduces a new issue in crda of setting not only power 
limits but power limits based on modulation.  It is permitted to use 
DSSS up to 100 watts, however, OFDM is permitted up to 1500 watts.

Would it be an unreasonable request to have crda support modulation 
restrictions and power limit based on modulation restrictions?

Thanks,
Rick Farina
>   Luis
>
>   

