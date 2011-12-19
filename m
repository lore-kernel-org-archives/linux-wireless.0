Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1LSP43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 10:56:29 -0500
Subject: Re: [PATCH] mac80211: Remove superfluous
 ieee80211_rx_h_remove_qos_control
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1324291194-28203-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111219_114031_877929_3E08F925)
References: <1324291194-28203-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111219_114031_877929_3E08F925)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 16:56:27 +0100
Message-ID: <1324310187.3414.4.camel@jlt3.sipsolutions.net> (sfid-20111219_165637_742360_0D70E748)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 11:39 +0100, Helmut Schaa wrote:
> This seems to not serve any purpose anymore, at least all frame
> processing afterwards seems to be able to deal with QoS frames. So,
> let's save the expensive memmove and just leave the QoS header in the
> 802.11 frame for further processing.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> It wouldn't hurt if a second pair of eyes looks through the rx path
> to see if there's any possible problem with QoS frames in later rx
> handlers.

Ok, but I'm on vacation until next year, so I don't know if I'll get to
it. In principle, this seems fine, but I'd feel more comfortable if
somebody else took another look. Not that I don't trust you, just more
eyes see more things :-)

johannes

