Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:60105 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab2FGJeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:34:21 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
Date: Thu, 7 Jun 2012 10:34:03 +0100
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk> <201205291212.46377.tvrtko.ursulin@onelan.co.uk> <20420.48433.260465.183715@gargle.gargle.HOWL>
In-Reply-To: <20420.48433.260465.183715@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206071034.03983.tvrtko.ursulin@onelan.co.uk> (sfid-20120607_113425_819903_0B19F39C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 May 2012 13:12:33 Sujith Manoharan wrote:
> > 118.779362 - 118.795238 (WARN_ON WARNING: at
> > drivers/net/wireless/ath/ath9k/recv.c:531 ath_stoprecv+0x118/0x130
> > [ath9k]())
> > 
> > 524.162432 - 524.753750
> > 1544.610658 - 1550.218324
> > 1685.668241 - 1686.991166
> > 1773.268867 - 1804.465933
> > 
> > Hope this helps?
> 
> Yes !
> 
> Here are a couple of patches to help narrow down the issue.
> 
> http://sujith.github.com/patches/wl/0001-ath9k-Add-some-debug-messages.patc
> h
> http://sujith.github.com/patches/wl/0002-ath9k-Resync-beacons-after-a-rese
> t.patch
> 
> The first one adds some messages, the second sets up beacons properly in
> case a HW reset happens. Can you try these and post the log ?
> 
> If you are willing to move to a more recent kernel, then current
> wireless-testing would be a good choice since it has various driver fixes.
> There are a few pending ath9k patches which have not been merged yet, you
> can find it here:
> 
> http://sujith.github.com/patches/wl/wl-ath9k-May-29-2012.patch

For the record, we swapped the mini PCI card to a different one of the same 
model and now it seems to work fine. Could you imagine a hardware fault or 
tolerance issue causing such errors?

Best regards,

Tvrtko
