Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33600 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYLWVPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 16:15:14 -0500
Date: Tue, 23 Dec 2008 16:07:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: allow mode change if IBSS is not allowed
Message-ID: <20081223210705.GA12572@tuxdriver.com> (sfid-20081223_221520_496438_0802044B)
References: <20081222213935.26129.4212.stgit@dv.roinet.com> <1229982778.3775.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229982778.3775.0.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 10:52:58PM +0100, Johannes Berg wrote:
> On Mon, 2008-12-22 at 16:39 -0500, Pavel Roskin wrote:
> > Changing mode on an interface is not allowed if IBSS is disabled for the
> > current channel.  That restriction should only apply when switching to
> > the ad-hoc mode, as it was prior to db17d8c4.
> > 
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> 
> Thanks Pavel.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Doesn't this need to account for the other beaconing modes?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
