Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1KPOlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:41:18 -0500
Subject: Re: [PATCH] iw: fix wifi wmm ie print function
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321448111-24476-1-git-send-email-yoni.divinsky@ti.com> (sfid-20111116_135533_879145_B1F0AEB3)
References: <1321448111-24476-1-git-send-email-yoni.divinsky@ti.com>
	 (sfid-20111116_135533_879145_B1F0AEB3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 15:41:13 +0100
Message-ID: <1321454473.4502.1.camel@jlt3.sipsolutions.net> (sfid-20111116_154120_573159_D3CC0B15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 14:55 +0200, Yoni Divinsky wrote:
> When printing the acm bit of the wifi wmm ie, the incorrect bit
> was being printed.

Applied.

johannes

