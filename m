Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYLCV1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 16:27:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 13:27:48 -0800
Date: Wed, 3 Dec 2008 13:27:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Colin McCabe <colin@cozybit.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH] ath9k: Replace ath9k_opmode with nl80211_iftype
Message-ID: <20081203212746.GC6522@tesla> (sfid-20081203_222753_151667_54470D98)
References: <1228167535-6501-1-git-send-email-colin@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228167535-6501-1-git-send-email-colin@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 01:38:55PM -0800, Colin McCabe wrote:
> This patch kills ath9k's ath9k_opmode enum by replacing it with nl80211_iftype.
> 
> Signed-off-by: Colin McCabe <colin@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
