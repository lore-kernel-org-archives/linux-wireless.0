Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3ADNIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 08:08:37 -0500
Message-ID: <1357304925.11302.6.camel@jlt4.sipsolutions.net> (sfid-20130104_140840_832617_B735030F)
Subject: Re: [PATCHv5 6/8] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 04 Jan 2013 14:08:45 +0100
In-Reply-To: <20130102150555.GC7794@pandem0nium>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-7-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357134319.9839.32.camel@jlt4.sipsolutions.net>
	 <20130102150555.GC7794@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 16:05 +0100, Simon Wunderlich wrote:

> > Also, we already have an event to notify of an AP channel change, maybe
> > that should be used? If not, why not?
> 
> The NL80211_CMD_CH_SWITCH_NOTIFY event is already present and not introduced
> with this patch, but reused for AP. Which other event do you mean for this
> purpose?

Ah ok, never mind then.

johannes

