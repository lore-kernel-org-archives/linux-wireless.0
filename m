Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVUTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 15:19:38 -0500
Message-ID: <1356207598.10280.0.camel@jlt4.sipsolutions.net> (sfid-20121222_211941_985778_45B0BD17)
Subject: Re: [PATCH 16/17] cw1200:  Integration into the kernel build system
From: Johannes Berg <johannes@sipsolutions.net>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 22 Dec 2012 21:19:58 +0100
In-Reply-To: <1356191120-5280-17-git-send-email-pizza@shaftnet.org> (sfid-20121222_164608_117682_BDA1247A)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
	 <1356191120-5280-17-git-send-email-pizza@shaftnet.org>
	 (sfid-20121222_164608_117682_BDA1247A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-12-22 at 10:45 -0500, Solomon Peachy wrote:

> +config CW1200
> +       tristate "CW1200 WLAN support"
> +       select MAC80211
> +       select CFG80211

You should depend on mac80211/cfg80211, they in turn have dependencies
that can't be resolved this way.

johannes

