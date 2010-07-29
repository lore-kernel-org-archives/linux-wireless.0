Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2155 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0G2Ck7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 22:40:59 -0400
Subject: Re: [PATCH] cfg80211: fix dev <-> wiphy typo
From: Joe Perches <joe@perches.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201007290128.46773.chunkeey@googlemail.com>
References: <201007290128.46773.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:40:56 -0700
Message-ID: <1280371256.24054.129.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-29 at 01:28 +0200, Christian Lamparter wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ae80f8f..2fd06c6 100644
> -	dynamic_pr_debug("%s: " format,	wiphy_name(dev), ##args)
> +	dynamic_pr_debug("%s: " format,	wiphy_name(wiphy), ##args)

Thanks for noticing that Christian.

