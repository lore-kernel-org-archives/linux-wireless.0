Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbZBMX4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 18:56:11 -0500
Date: Fri, 13 Feb 2009 15:43:39 -0800
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] mac80211: avoid possible buffer overrun in
	sta_agg_status_write
Message-ID: <20090213234339.GB14657@kroah.com> (sfid-20090214_005619_955393_99C41976)
References: <1226089619-726-1-git-send-email-linville@tuxdriver.com> <20090208202527.GD17043@kroah.com> <20090213213050.GJ3581@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090213213050.GJ3581@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 04:30:50PM -0500, John W. Linville wrote:
> On Sun, Feb 08, 2009 at 12:25:27PM -0800, Greg KH wrote:
> > 
> > John, the patch below seems to have David Miller's ack that he applied
> > it to a tree back in November, but I don't see it in Linus's tree
> > anywhere.  Did something happen to it?
> 
> I think Dave applied a slightly different patch to do more-or-less
> the same thing.
> 
> commit 013cd397532e5803a1625954a884d021653da720
> Author: Jianjun Kong <jianjun@zeuux.org>
> Date:   Mon Nov 10 21:37:39 2008 -0800

Ah, thanks, I missed that, I'll go add it to the queue.

greg k-h
