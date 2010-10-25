Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0JYI3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 04:29:18 -0400
Subject: Re: [PATCH] iw: Add ibss join parameter for beacon interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101019073141.14128.29518.stgit@localhost6.localdomain6>
References: <20101019073141.14128.29518.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:26:16 +0200
Message-ID: <1287995176.3587.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-19 at 16:31 +0900, Bruno Randolf wrote:

> +	if (argc > 1 && strcmp(argv[0], "bintval") == 0) {

I'd prefer this to be called just "bi" or fully spelt out.

>  	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
>  	"Leave the current IBSS cell.");
>  COMMAND(ibss, join,
> -	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
> +	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [bintval <ms>] "

It's not in ms, but TU. *sigh*

johannes

