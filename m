Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53606 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYIVVRm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 17:17:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Mon, 22 Sep 2008 23:16:47 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809201520.28717.IvDoorn@gmail.com> <20080922030137.GA1817@khazad-dum.debian.net>
In-Reply-To: <20080922030137.GA1817@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809222316.47466.mb@bu3sch.de> (sfid-20080922_231746_686905_58323898)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 September 2008 05:01:37 Henrique de Moraes Holschuh wrote:
> As long as the drivers based on mac80211 still know it is rfkill they're
> dealing with (i.e. as long as they will know they MUST NOT emit energy from
> the transmitter when they're soft-blocked),

That's the only policy that makes sense. So I don't think it would be a problem.
IMO that's how the mac80211 config API is defined, currently.

-- 
Greetings Michael.
