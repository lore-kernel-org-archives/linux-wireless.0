Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:15187 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbYAUCQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 21:16:49 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3394084wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 18:16:46 -0800 (PST)
Message-ID: <43e72e890801201816n3609aaa2s2debaf609bed4fb@mail.gmail.com> (sfid-20080121_021707_787671_C58194AE)
Date: Sun, 20 Jan 2008 21:16:46 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 2/2] ath5k: always extend rx timestamp with tsf
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080121020945.3818.74270.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080121020924.3818.46553.stgit@one>
	 <20080121020945.3818.74270.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 20, 2008 9:09 PM, Bruno Randolf <bruno@thinktube.com> wrote:
> always extend the rx timestamp with the local TSF, since this information is
> also needed for proper IBSS merging. this is done in the tasklet for now, maybe
> has to be moved to the interrupt handler like in madwifi.
>
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
