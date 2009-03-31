Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZCaT47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 15:56:59 -0400
Date: Tue, 31 Mar 2009 15:56:38 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: convert to use linux/ieee80211.h
Message-ID: <20090331195638.GB25513@bombadil.infradead.org> (sfid-20090331_215702_187203_763E5A11)
References: <20090222120434.20821.88974.stgit@tikku> <20090331040147.GA15550@bombadil.infradead.org> <87ab71sx7p.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ab71sx7p.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 03:17:30PM +0300, Kalle Valo wrote:
> At least the patch is in Greg's staging directory:
> 
> http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/staging-at76_usb-convert-to-use-linux-ieee80211.h.patch
> 
> I would assume that Greg pushes it forward at some point.
> 

Ah, apologies. I forgot Greg uses that quilt tree and didn't find it
merged when I looked.

regards, Kyle
