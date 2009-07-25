Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:63868 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZGYQRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 12:17:19 -0400
Message-ID: <4A6B3027.7080200@lwfinger.net>
Date: Sat, 25 Jul 2009 11:17:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix an oops in ieee80211_scan_state_set_channel
References: <200907251725.52084.helmut.schaa@googlemail.com>
In-Reply-To: <200907251725.52084.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> Fix an oops in ieee80211_scan_state_set_channel which was triggered
> if the last scanned channel was skipped (for example due to regulatory
> restrictions) by returning to the decision state after each skipped
> channel.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---

Better late than never, but this patch does fix the problem for me.

Larry

