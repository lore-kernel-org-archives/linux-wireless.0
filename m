Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36958 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832AbbIVXPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 19:15:09 -0400
Date: Tue, 22 Sep 2015 16:15:08 -0700 (PDT)
Message-Id: <20150922.161508.1548783571595972129.davem@davemloft.net> (sfid-20150923_011905_088150_24EE128D)
To: a.hajda@samsung.com
Cc: linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
	m.szyprowski@samsung.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 22/38] orinoco: fix checking for default value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1442842450-29769-23-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
	<1442842450-29769-23-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>
Date: Mon, 21 Sep 2015 15:33:54 +0200

> Thresholds uses -1 to indicate that default value should be used.
> Since thresholds are unsigned sign checking makes no sense.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2038576
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Applied.
