Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42541 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAKQxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 11:53:04 -0500
Date: Sun, 11 Jan 2009 17:53:01 +0100
From: Andreas Mohr <andi@lisas.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andreas Mohr <andi@lisas.de>, linville@tuxdriver.com,
	maximlevitsky@gmail.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090111165301.GA20335@rhlx01.hs-esslingen.de> (sfid-20090111_175308_951296_92C56719)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com> <20090111131015.GA31037@rhlx01.hs-esslingen.de> <20090111144227.GB13109@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090111144227.GB13109@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2009 at 09:42:27AM -0500, Bob Copeland wrote:
> On Sun, Jan 11, 2009 at 02:10:15PM +0100, Andreas Mohr wrote:
> > My LED is dead again on 2.6.29-rc1 (reason: doesn't contain this patch).
> 
> It's in wireless-testing, it just hasn't made it through the pipeline yet.

Thanks, then consider my blurb a heads-up only ;)

BTW, .29-rc1 is a veritable -rc1, there already are about 3 official
suspend/resume regression reports and I've got yet another _different_
one even (for me it locks up on suspend instead of on resume,
and no_console_suspend doesn't help to debug it either...).

So Maxim, if you've got time to waste here's your project ;)

(and if I am forced to endure yet another STR regression then my mood is
going to blow up...)

(and no, unloading microcode, ath5k, snd_hda_intel and r8169 does not work,
plus I've got no time for debugging anyway)

Andreas
