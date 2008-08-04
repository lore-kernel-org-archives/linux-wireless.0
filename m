Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60195 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYHDMj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 08:39:59 -0400
Subject: Re: [PATCH 3/4] ath5k: remove Atheros 11n devices from supported
	list
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1217834201-14680-4-git-send-email-lrodriguez@atheros.com>
References: <1217834201-14680-1-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-2-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-3-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 08:39:57 -0400
Message-Id: <1217853597.27237.1.camel@dv> (sfid-20080804_144002_232664_ACDD9A7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 00:16 -0700, Luis R. Rodriguez wrote:
> Remove Atheros 11n devices from being claimed by ath5k as its
> now handled by ath9k.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
