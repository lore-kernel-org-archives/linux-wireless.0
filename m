Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:45016 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932598Ab0BYNyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 08:54:13 -0500
Message-ID: <4B868103.6030704@yahoo.com>
Date: Thu, 25 Feb 2010 14:54:11 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00 : fix txdone implementation
References: <4B85CA62.8080208@yahoo.com> <20100224205814.974teh5rf48w4g8o-cebfxv@webmail.spamcop.net>
In-Reply-To: <20100224205814.974teh5rf48w4g8o-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 02:58, Pavel Roskin wrote:
> Quoting Alban Browaeys <prahal@yahoo.com>:
>
>> Properly move to the headroom position in dma mapped skb. The hw extra
>> headroom is now taken into account.
>>
>> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ...
>> -    rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
>> -               skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
>> +    rt2x00_set_field32(&word, TXD_W2_SD_PTR1, skbdesc->skb_dma
>> +               + rt2x00dev->ops->extra_tx_headroom);
>
> I think it's just a formatting change.  I would not mix formatting 
> changes with the real fixes.  I can understand reformatting code that 
> is also modified in some other way, but that's even a separate function.
>

Thank you. There was a real change (I did not meant for to reformat this 
line) but it got merged and I did not saw it.
I sent a new version of the patch without the first now uneeded change.

Best regards,
Alban
