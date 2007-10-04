Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbXJDNjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 09:39:06 -0400
Date: Thu, 4 Oct 2007 09:08:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: adjust for changed nl80211
Message-ID: <20071004130825.GB6037@tuxdriver.com> (sfid-20071004_143921_537705_E5B030A6)
References: <1191069453.22960.77.camel@johannes.berg> <20071003030951.GH933@jm.kir.nu> <1191393995.4178.0.camel@johannes.berg> <20071004040957.GM933@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071004040957.GM933@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 03, 2007 at 09:09:57PM -0700, Jouni Malinen wrote:
> On Wed, Oct 03, 2007 at 08:46:35AM +0200, Johannes Berg wrote:
> > On Tue, 2007-10-02 at 20:09 -0700, Jouni Malinen wrote:
> > > I did not find this change from wireless-dev.git#everything.. Am I
> > > missing something or has this not been applied to the kernel yet?
> > 
> > You missed that wireless-dev is dead and we're using
> > wireless-2.6#everything now.
> 
> OK. Though, hostapd does not build at all against that due to
> net/mac80211/hostapd_ioctl.h not existing.. Anyway, with a copy of

Until Johannes starts hosting his mac80211-hostap tree, I think you
can use wireless-2.6#mac80211-attic.  I've been trying to keep that
available for those who need it in the meantime.  Fair warning,
it is untested and may simply not work...

Hth?

John
-- 
John W. Linville
linville@tuxdriver.com
