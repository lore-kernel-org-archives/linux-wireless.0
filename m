Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1D0SII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 14:08:08 -0400
Subject: Re: [PATCH] compat: backport vzalloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1303927456-7067-1-git-send-email-hauke@hauke-m.de> (sfid-20110427_200428_132859_14FBE974)
References: <1303927456-7067-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20110427_200428_132859_14FBE974)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 20:08:05 +0200
Message-ID: <1303927685.3542.6.camel@jlt3.sipsolutions.net> (sfid-20110427_200811_746989_79E2B029)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-27 at 20:04 +0200, Hauke Mehrtens wrote:

> +	void *buf;
> +	buf = vmalloc(size);
> +	memset(buf, 0, size);
> +	return buf;

vmalloc can fail, right?

johannes

