Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:45190 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1FBG14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 02:27:56 -0400
Date: Wed, 1 Jun 2011 23:20:55 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
cc: Andreas Schwab <schwab@linux-m68k.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org, linuxppc-dev@ozlabs.org
Subject: Re: [RFT][PATCH 3.0] ssb: fix PCI(e) driver regression causing oops
 on PCI cards
In-Reply-To: <BANLkTi=mbBiSOGbEZ4AEYqZgyvgW0oXKtw@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1106012317230.21697@trent.utfs.org> (sfid-20110602_082800_997785_484E6AB6)
References: <1306918871-16965-1-git-send-email-zajec5@gmail.com> <BANLkTinSdDZv7gshYfi4mK5N9K-E7vk3Yw@mail.gmail.com> <BANLkTi=mbBiSOGbEZ4AEYqZgyvgW0oXKtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2 Jun 2011 at 08:13, Rafał Miłecki wrote:
> John, I'm afraid more and more people get angry at me because of this ;)

Erm, I'm not angry at anyone :-) On the contrary, I'm happy about the fix 
so quickly available!

Though I'm a bit afraid of the next git bisect session, as it might not be 
so straightforward than this one...

Thanks to all involved,
Christian.
-- 
BOFH excuse #230:

Lusers learning curve appears to be fractal
