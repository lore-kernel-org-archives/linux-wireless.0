Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:63601 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYAJXiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 18:38:08 -0500
Received: by py-out-1112.google.com with SMTP id u52so1298178pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 15:38:07 -0800 (PST)
Message-ID: <43e72e890801101538r674e7891p5ace9593e819e5e3@mail.gmail.com> (sfid-20080110_233812_533158_E8368591)
Date: Thu, 10 Jan 2008 18:38:06 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/1] ath5k: remove duplicate bssid variable
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1199945189-22180-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1199945189-22180-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 10, 2008 1:06 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> struct ath5k_hw included two different variables for caching the bssid. remove
> one of them.
>
> drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
> drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
