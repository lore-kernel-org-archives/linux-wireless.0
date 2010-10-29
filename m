Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab0J2Lfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 07:35:39 -0400
Subject: Re: [RFC PATCH 0/2] mac80211: Possibility for driver to get AP
 probereq template
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288351673-12224-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1288351673-12224-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 13:35:36 +0200
Message-ID: <1288352136.3826.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-29 at 14:27 +0300, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The wl1271 has hardware connection monitoring, i.e. the hardware chipset 
> internally handles periodic null-funcs and probe-req transmitting in case of
> non-acked periodic null-func or beacon loss.

I'm wondering why it wants to do probe-req instead of nullfunc? I mean,
we're trying to make mac80211 use nullfunc+ACK instead of probereq
+proberesp ...

johannes

