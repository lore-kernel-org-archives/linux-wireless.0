Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3APWoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:44:32 -0500
Message-ID: <1358376287.15012.32.camel@jlt4.sipsolutions.net> (sfid-20130116_234435_784908_3E50780E)
Subject: Re: [PATCHv6 2/6] cfg80211: check radar interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 16 Jan 2013 23:44:47 +0100
In-Reply-To: <1358376177.15012.31.camel@jlt4.sipsolutions.net> (sfid-20130116_234247_634938_6B0564B1)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1358376177.15012.31.camel@jlt4.sipsolutions.net>
	 (sfid-20130116_234247_634938_6B0564B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 23:42 +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
> > To ease further DFS development regarding interface combinations, use
> > the interface combinations structure to test for radar capabilities.
> > Drivers can specify which channel widths they support, and in which
> > modes. Drivers should first allow AP mode only, but can later allow
> > MultiSSID APs, AP+Ad-Hoc, etc.
> 
> Applied.

Btw, an iw patch would be nice.

johannes

