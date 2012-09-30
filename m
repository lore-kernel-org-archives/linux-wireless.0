Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3TeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 15:34:22 -0400
Message-ID: <1349033683.23838.6.camel@jlt4.sipsolutions.net> (sfid-20120930_213433_524331_68655D27)
Subject: Re: [PATCH] ath/ath9k/ar9003_eeprom.c: Remove unnecessary semicolon
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Date: Sun, 30 Sep 2012 21:34:43 +0200
In-Reply-To: <1349032870-4780-1-git-send-email-peter.senna@gmail.com> (sfid-20120930_212132_608267_30BA39AB)
References: <1349032870-4780-1-git-send-email-peter.senna@gmail.com>
	 (sfid-20120930_212132_608267_30BA39AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 21:21 +0200, Peter Senna Tschudin wrote:

> -		if (!ah->config.enable_paprd);
> +		if (!ah->config.enable_paprd)
>  			return false;

That's not an "unnecessary semicolon", it's a pretty strange bug :)

johannes

