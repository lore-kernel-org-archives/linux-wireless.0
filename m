Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2FNHNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 03:13:37 -0400
Message-ID: <1339658006.4909.3.camel@jlt3.sipsolutions.net> (sfid-20120614_091341_570836_F1584018)
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth
 frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2012 09:13:26 +0200
In-Reply-To: <4FD8B5D4.8060305@opentechinstitute.org>
References: <4FD8B5D4.8060305@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 11:46 -0400, Will Hawkins wrote:
> Hello all!
> 
> This patch allows userspace applications to use nl80211 to register for
> AUTH frames received on adhoc interfaces.
> 
> Thanks,
> Will
> 
> Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>

Thanks for the patch. Can I get you to write a better commit log? :-)

You should remove the "Hello" and "Thanks" portions, they shouldn't go
into the kernel's commit log after all. And then, even if I already
know, please explain in the commit log why you're making this change so
the reason gets recorded in the kernel's commit log.

Thanks,
johannes


