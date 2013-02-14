Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661Ab3BNPnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 10:43:11 -0500
Message-ID: <1360856587.8210.3.camel@jlt4.sipsolutions.net> (sfid-20130214_164314_974346_868ABB52)
Subject: Re: [PATCH] mac80211: fix ieee80211_sta_tx_notify for nullfunc
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, mcider@gmail.com
Date: Thu, 14 Feb 2013 16:43:07 +0100
In-Reply-To: <1360847317-31387-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130214_141423_159188_29A3B6F6)
References: <1360847317-31387-1-git-send-email-Wojciech.Dubowik@neratec.com>
	 (sfid-20130214_141423_159188_29A3B6F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 14:08 +0100, Wojciech Dubowik wrote:
> Function ieee80211_sta_reset_conn_monitor has been
> resetting probe_send_count too early and nullfunc
> check was never called after succesfull ack.
> 
> Reported-by: Magnus Cederlöf <mcider@gmail.com>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Applied, thanks!

johannes

