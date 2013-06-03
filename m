Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab3FCTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 15:15:08 -0400
Date: Mon, 3 Jun 2013 15:05:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-06-03
Message-ID: <20130603190554.GG2727@tuxdriver.com> (sfid-20130603_211515_373871_7CE8BB91)
References: <1370270859.8227.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370270859.8227.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 04:47:39PM +0200, Johannes Berg wrote:
> John,
> 
> Here's one more fix for mac80211 (along with a constify patch it depends
> on) to work around problems with certain (broken) APs that forget to
> include HT IEs in their association responses.
> 
> johannes
> 
> 
> The following changes since commit ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b:
> 
>   mac80211: Allow single vif mac address change with addr_mask (2013-05-27 11:26:48 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to c2c15e215e860c99b86ddfc4be4bb25cf180fed0:
> 
>   mac80211: work around broken APs not including HT info (2013-05-29 00:56:13 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
