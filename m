Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYIVGy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 02:54:56 -0400
Date: Sun, 21 Sep 2008 23:54:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ingo Molnar <mingo@elte.hu>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080922065453.GD19580@tesla> (sfid-20080922_085501_231996_815879C3)
References: <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com> <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com> <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com> <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com> <1221944338.3023.8.camel@johannes.berg> <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com> <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com> <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com> <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com> <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 06:48:05PM -0700, Steven Noonan wrote:
> 
> OK, here's the time index at which it b0rked:
> 
> 18:28:42          sum   1155.00
> 18:28:43          sum   1339.00
> 18:28:44          sum  18355.00
> 18:28:45          sum  17845.45
> 
> And the entire log of the minute 18:28 is here:
> http://www.uplinklabs.net/~tycho/linux/18.28.00-59.log.gz
> 
> It looks pretty crazy.

Thanks, I'll take a look when I get a chance (remember aggretion
is in the queue too) unless someone beats me to it. Asking in advance
-- if you can also provide a log of minutes 43, 44 and 45 that would
be great, but this may just be enough.

  Luis
