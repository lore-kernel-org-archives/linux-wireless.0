Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3026 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZAKOmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 09:42:39 -0500
Date: Sun, 11 Jan 2009 09:42:27 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Mohr <andi@lisas.de>
Cc: linville@tuxdriver.com, maximlevitsky@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090111144227.GB13109@hash.localnet> (sfid-20090111_154243_733808_3BCF54C9)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com> <20090111131015.GA31037@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090111131015.GA31037@rhlx01.hs-esslingen.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2009 at 02:10:15PM +0100, Andreas Mohr wrote:
> On Thu, Jan 01, 2009 at 03:01:44PM -0500, Bob Copeland wrote:
> > Add vendor ID for Foxconn and use it to set the ath5k LED gpio and
> > polarity for Acer branded laptops.
> 
> My LED is dead again on 2.6.29-rc1 (reason: doesn't contain this patch).

It's in wireless-testing, it just hasn't made it through the pipeline yet.

-- 
Bob Copeland %% www.bobcopeland.com

