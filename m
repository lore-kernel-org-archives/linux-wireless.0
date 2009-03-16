Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47780 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZCPNl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 09:41:58 -0400
Date: Mon, 16 Mar 2009 14:41:56 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090316134156.GB8437@rhlx01.hs-esslingen.de> (sfid-20090316_144202_514413_811DAE51)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com> <20090111131015.GA31037@rhlx01.hs-esslingen.de> <20090111144227.GB13109@hash.localnet> <20090316100447.GA13819@rhlx01.hs-esslingen.de> <1237198577.27769.9.camel@johannes.local> <20090316104433.GA24968@rhlx01.hs-esslingen.de> <1237206117.15040.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237206117.15040.7.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Mar 16, 2009 at 02:21:57PM +0200, Maxim Levitsky wrote:
> On the other hand think about my main notebook, acer 5720.
> There suspend to ram doesn't work, and no this isn't due to GFX driver,
> or anything like that. It just that BIOS doesn't pass control to linux
> on resume. It doesn't like something in hardware....
> This would I call a NOTHING...

Hmm. So the resume vector itself doesn't even get invoked?
AFAIR there's some debugging options at the asm entry point,
but I'm sure you (and several other people) have already looked at this...
Plus booting into a minimal setup (init=/bin/sh) with almost no drivers
loaded at all (thus no fumbled hardware) didn't manage to make resume
work either I guess?

> I recommend to to install (if you didn't do that yet) the
> compat-wireless package, or even better compile wireless-testing.

Thanks, forgot to install this for the newly installed Jaunty's 2.6.28.

> You could also patch in latest patches that fix TX power for ath5k, or
> wait few days till they are in wireless-testings (maybe they are there
> already...)

I'll wait until I know how well ath5k works on -rc8.

Thanks,

Andreas Mohr
