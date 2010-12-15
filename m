Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38537 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab0LOWtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 17:49:31 -0500
Date: Thu, 16 Dec 2010 00:49:22 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] nl80211: Add notification for dropped
 Deauth/Disassoc
Message-ID: <20101215224922.GA19473@jm.kir.nu>
References: <20101213220048.GA24752@jm.kir.nu>
 <20101214084133.GA28466@jm.kir.nu>
 <20101215215610.GH2377@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101215215610.GH2377@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 04:56:11PM -0500, John W. Linville wrote:
> On Tue, Dec 14, 2010 at 10:41:33AM +0200, Jouni Malinen wrote:
> > +void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
> > +				   size_t len)

> > +EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);

> Need cfg80211.h bits for these, no?

Yes, indeed. Looks like a missing "quilt add" since I obviously do have
those prototypes for the build to go through without warnings... I'll
post a fixed version.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
