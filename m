Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33480 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaBFSJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 13:09:32 -0500
Received: by mail-vc0-f177.google.com with SMTP id if11so1706121vcb.22
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 10:09:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com>
References: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 7 Feb 2014 02:09:30 +0800
Message-ID: <CAEFj984TssetDfG=3FnvZhJVxsoYKba+ppoV4nV=R9psfs5B8g@mail.gmail.com> (sfid-20140206_190935_442519_8A0A9CEA)
Subject: Re: [PATCH] ath10k: implement sta_rc_update()
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -3091,6 +3160,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>                            "mac vdev %d peer create %pM (new sta) num_peers %d\n",
>                            arvif->vdev_id, sta->addr, ar->num_peers);
>
> +               memset(&arsta, 0, sizeof(*arsta));

Should be memset(arsta, 0, sizeof(*arsta)), right?

---
Chun-Yeow
