Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36985 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbbIVXPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 19:15:42 -0400
Date: Tue, 22 Sep 2015 16:15:41 -0700 (PDT)
Message-Id: <20150922.161541.158654696480248167.davem@davemloft.net> (sfid-20150923_011828_773587_3F992452)
To: a.hajda@samsung.com
Cc: linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
	m.szyprowski@samsung.com, brudley@broadcom.com, arend@broadcom.com,
	frankyl@broadcom.com, meuleman@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH 20/38] net: brcm80211: fix range check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1442842450-29769-21-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
	<1442842450-29769-21-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>
Date: Mon, 21 Sep 2015 15:33:52 +0200

> Unsigned minus constant is still unsigned so checking its sign makes no
> sense.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2038576
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Applied.
