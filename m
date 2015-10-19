Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:23128 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbbJSJKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:10:14 -0400
Subject: Re: FCC DFS support
To: Tim Harvey <tharvey@gateworks.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
References: <CAJ+vNU2q1kLBs8wXRN++62bn24ohthFr=0htDMBh7qxsqmeodg@mail.gmail.com>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <5624B374.5080209@neratec.com> (sfid-20151019_111020_918220_CB19D7D6)
Date: Mon, 19 Oct 2015 11:10:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2q1kLBs8wXRN++62bn24ohthFr=0htDMBh7qxsqmeodg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2015 06:53 PM, Tim Harvey wrote:
> Greetings,
> 
> Is FCC DFS support (from the updated rules released in Aug 2014) fully
> supported in ath10k by the driver/firmware/cards?
> 
> The linux-wireless DFS page [1] has some great info but doesn't really
> list what is currently in place and working and doesn't mention ath10k
> specifically and I didn't see anything on the ath10k page either [2].
> 
> Thanks for any info!
> 
> Regards,
> 
> Tim
> 
> [1] - https://wireless.wiki.kernel.org/en/developers/dfs
> [2] - https://wireless.wiki.kernel.org/en/users/drivers/ath10k
> --
> 

Hi Tim,

you're right, unfortunately the DFS documentation in [1] is quite outdated -
basically in its initial state from 2011 when ath10k was unknown. It took around
four years to get the work done, and since numerous parties contributed at
different times and different modules (driver, mac/cfg, hostapd), the
documentation has not always been updated accordingly.

But the more important fact is: yes, ath10 and ath9k today fully support FCC.

We certified one of our ath9k based products for FCC and ETSI some months ago, and
I got confirmations that ath10k also passed certification testing for FCC.

It is relevant to note that both drivers use the same radar pattern detector (and
all upper layers anyway), so that if ath9k passed, ath10k most probably will also
do (and vice versa).


Hth,
Zefir


