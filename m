Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37130 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZGZSA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 14:00:59 -0400
Date: Sun, 26 Jul 2009 13:52:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-07-24
Message-ID: <20090726175257.GA5630@tuxdriver.com>
References: <20090724193625.GB2711@tuxdriver.com> <20090726.100214.125172881.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090726.100214.125172881.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 26, 2009 at 10:02:14AM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 24 Jul 2009 15:36:25 -0400
> 
> > Here is the latest huge round of wireless patches intended for 2.6.32.
> > It hits all the usual areas (i.e. drivers, mac80211, and cfg80211) with
> > patches from all the usual suspects.  This includes the reworking of
> > mac80211 to eliminate the confusing "master netdev".
> > 
> > FWIW, my laptop has been happy with it.  Most of the bits here have been
> > in -next for at least a few days.
> > 
> > Please let me know if there are problems!
> 
> Pulled, thanks a lot John!
> 
> Please try to resolve the regression reports that I saw posted against
> wireless-testing on the same day you sent this pull request.

Certainly!  But FWIW I think most of those are about patches that I
have not yet sent to you, so I don't think you need to worry a lot
about your tree ATM.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
