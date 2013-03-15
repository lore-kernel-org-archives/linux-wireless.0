Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3CPM5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:03 -0400
Message-ID: <1363362363.8656.27.camel@jlt4.sipsolutions.net> (sfid-20130316_135707_018291_8E210FEE)
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
In-Reply-To: <20130310230600.GC3824@gobelin> (sfid-20130311_000527_640675_55BD82F8)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
	 <1362427924.21028.42.camel@jlt4.sipsolutions.net>
	 <20130304204541.GA8819@gobelin> <5135F327.4000408@openwrt.org>
	 <20130310221627.GA3824@gobelin> <513D08B5.1030007@openwrt.org>
	 <20130310230600.GC3824@gobelin> (sfid-20130311_000527_640675_55BD82F8)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:46:03 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 00:06 +0100, Karl Beldan wrote:

> > > Filtering is necessary to lookup alternative downgrade/upgrade rates.
> > Right, but the code could be changed to only do the filtering if
> > mac80211 needs to look up an alternative downgrade/upgrade rate.
> > 
> With this I agree.
> Do you have strong opinions wrt basic rates ? The current code might tx
> mc/bc with non-basic rates.

If the users want to shoot themselves in the foot I'd rather give them
enough rope to hang themselves with ;-)

johannes

