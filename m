Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43505 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZA1Sat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:30:49 -0500
Date: Wed, 28 Jan 2009 13:26:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: Creating new IBSS with fixed BSSID
Message-ID: <20090128182656.GA4198@tuxdriver.com> (sfid-20090128_193053_115171_E75085BD)
References: <20090128153012.138700@gmx.net> <87k58f74dk.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k58f74dk.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 07:00:07PM +0200, Kalle Valo wrote:
> "Alina Friedrichsen" <x-alina@gmx.net> writes:
> 
> > This fixes a bug when creating a new IBSS network with a fixed BSSID. The fixed BSSID situation is now with one of my last patches handled in ieee80211_sta_find_ibss() function.
> >
> > It's more robust to test against (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET), because ifsta->state is not seted right in every situation and so the creating of the new IBSS network sometimes hangs after the first try to scan for a network to merge.
> 
> Please line wrap your commit logs. Now you had very long lines.

ACK, please.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
