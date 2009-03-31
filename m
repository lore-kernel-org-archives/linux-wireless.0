Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZCaEBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 00:01:52 -0400
Date: Tue, 31 Mar 2009 00:01:47 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: convert to use linux/ieee80211.h
Message-ID: <20090331040147.GA15550@bombadil.infradead.org> (sfid-20090331_060153_728596_E856FC63)
References: <20090222120434.20821.88974.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090222120434.20821.88974.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2009 at 02:04:34PM +0200, Kalle Valo wrote:
> Jason Andryuk noticed that at76_usb won't compile with current
> wireless-testing tree. This is because net/ieee80211.h was missing.
> 
> net/ieee80211.h will be removed soon and at76_usb won't compile then that
> happens. Preprare for that by using instead linux/ieee80211.h and copying
> some structures not available.
> 
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

Ping? This is still an issue in git head... Should probably go in via
the staging tree...

regards, Kyle
