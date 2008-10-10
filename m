Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753121AbYJJQVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:21:40 -0400
Date: Fri, 10 Oct 2008 09:01:57 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable <stable@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH v2.6.27] mac80211: fix two issues in debugfs
Message-ID: <20081010160157.GA26323@kroah.com> (sfid-20081010_182143_972444_832A6EC2)
References: <1223653970.3748.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223653970.3748.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 05:52:49PM +0200, Johannes Berg wrote:
> This fixes RHBZ 466264, whenever the master interface is
> renamed this code would BUG_ON. Also fixes a separately
> reported bug with the debugfs dir being NULL.
> 
> This patch is not applicable to the next kernel version
> because both these issues have been fixed, the first one
> by not having the master interface have a ieee80211_ptr
> at all, and the second one by also leaving the function
> early.

So this will not be going into .28, right?  What -stable trees should it
go to, .27?  .26?  .25?

thanks,

greg k-h
