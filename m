Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2FTRkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 13:40:21 -0400
Message-ID: <1340214021.4655.79.camel@jlt3.sipsolutions.net> (sfid-20120620_194024_929586_3A7BB8F6)
Subject: Re: [PATCH v2 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 19:40:21 +0200
In-Reply-To: <CAK80WHZ+JBP2C8vCpYTcbr15wnNCxaS5piG1znjFgzS2n7Mouw@mail.gmail.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340181600.4655.34.camel@jlt3.sipsolutions.net>
	 <CAK80WHZ+JBP2C8vCpYTcbr15wnNCxaS5piG1znjFgzS2n7Mouw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 19:42 +0300, Goldenshtein, Victor wrote:

> > How do you intend to handle HT40?
> >
> 
> At this point we don't have such intention, but as Zefir suggested
> lets first implement HT20.
> To protect from transmitting on HT40 , while CAC was performed only
> for HT20, will add additional check in enable_tx to validate that
> we're on NL80211_CHAN_HT20 channel, otherwise will return -EINVAL.
> Also, will add NL80211_ATTR_WIPHY_CHANNEL_TYPE to the
> ap_channel_switch command.

Ok, makes sense, thanks

johannes

