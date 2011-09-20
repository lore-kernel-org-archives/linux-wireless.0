Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52776 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1ITNaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:30:35 -0400
Date: Tue, 20 Sep 2011 09:22:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: Franky Lin <frankyl@broadcom.com>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110920132203.GB7800@tuxdriver.com> (sfid-20110920_153039_201077_5519DE38)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110920130338.GA9885@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 06:03:38AM -0700, Greg KH wrote:
> On Mon, Sep 19, 2011 at 02:25:48PM -0700, Franky Lin wrote:
> > Code clean up for fullmac.
> 
> Ok, this is the 7th patch series since the last round of "how do we get
> our driver into mainline" happened.
> 
> And while code is great and nice, I still haven't seen any real answers
> to all of the questions that were asked of the Broadcom driver team
> during that review by the linux-wireless developers about how things
> will be handled properly due to the overlap in functionality with the
> existing "real" driver in the tree.
> 
> So, can you please start answering these questions?  I'm loath to keep
> accepting patches until that all gets straightened out as it potentially
> wastes my, and your, time by doing so.
> 
> In other words, I'm not going to apply any more patches until this gets
> resolved.  Consider this patchset dropped from my to-apply queue for now
> because of that.

I think most of the outstanding series from Broadcom are
(almost?) exclusively for their fullmac driver, which has not overlap
with b43.  We should be moving forward toward getting the fullmac
driver into wireless-next.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
