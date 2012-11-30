Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307Ab2K3VLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 16:11:32 -0500
Message-ID: <1354309913.24302.0.camel@jlt4.sipsolutions.net> (sfid-20121130_221135_674235_33BB1EE1)
Subject: Re: [PATCH] mac80211: fix redundant if in transmit path
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 30 Nov 2012 22:11:53 +0100
In-Reply-To: <1354303514-20255-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354303514-20255-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 20:25 +0100, Simon Wunderlich wrote:
> This is already in the right switch branch, no need to check again and
> provoke a compiler warning about chanctx_conf might be used
> uninitialized.

Nope, look again.

johannes

