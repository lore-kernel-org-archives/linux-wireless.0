Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:41771 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbXGIFc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 01:32:58 -0400
Message-ID: <4691C887.7020309@warmcat.com>
Date: Mon, 09 Jul 2007 06:32:55 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org> <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>
In-Reply-To: <20070708140054.GA28113@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulrich Kunitz wrote:
> On 07-07-06 16:13 Andy Green wrote:
> 
>> Daniel Drake wrote:
>>> Andy Green wrote:
>>>> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
>>>> on radiotap rx, last sent here 11 June.
>>>>
>>>> http://www.spinics.net/lists/linux-wireless/msg02897.html
>> ...
>>> Are we really sure we need another rate conversion function? there are
>>> already a couple in the mac80211 driver, and one or 2 extra (for RTS/CTS
>>> rate programming) in the softmac driver.
> 
> I have created a commit (24b5500dc) in my Git tree that
> implements Andy's patch. I didn't introduce a new rate conversion
> function, but changed only zd_rx_rate(). The function is only used
> for filling the ieee80211_rx_status structure.

I tested this together with the new hardware promisc rx patches and it
works fine.  Thanks!

-Andy
