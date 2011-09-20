Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35888 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1ITNEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:04:20 -0400
Date: Tue, 20 Sep 2011 06:03:38 -0700
From: Greg KH <greg@kroah.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110920130338.GA9885@kroah.com> (sfid-20110920_150440_808230_86E73445)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 02:25:48PM -0700, Franky Lin wrote:
> Code clean up for fullmac.

Ok, this is the 7th patch series since the last round of "how do we get
our driver into mainline" happened.

And while code is great and nice, I still haven't seen any real answers
to all of the questions that were asked of the Broadcom driver team
during that review by the linux-wireless developers about how things
will be handled properly due to the overlap in functionality with the
existing "real" driver in the tree.

So, can you please start answering these questions?  I'm loath to keep
accepting patches until that all gets straightened out as it potentially
wastes my, and your, time by doing so.

In other words, I'm not going to apply any more patches until this gets
resolved.  Consider this patchset dropped from my to-apply queue for now
because of that.

thanks,

greg k-h
