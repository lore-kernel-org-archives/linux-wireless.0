Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0G1GwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 02:52:15 -0400
Subject: Re: [PATCH 2/3] mac80211_hwsim: supress scan conflict message
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1280262788-9890-3-git-send-email-lrodriguez@atheros.com>
References: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
	 <1280262788-9890-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 08:52:09 +0200
Message-ID: <1280299929.3832.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-27 at 16:33 -0400, Luis R. Rodriguez wrote:
> Johannes already debugged this and determined it was due
> to a race condition in mac80211, in order to fix this though
> we would need to change drivers quite a bit so for now just
> supress this and we'll correct this on the next kernel release.

This one can stay for all I care since it's not used in practise by
actual users that get confused :-)

johannes

