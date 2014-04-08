Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbaDHKE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 06:04:26 -0400
Message-ID: <1396951464.5936.17.camel@jlt4.sipsolutions.net> (sfid-20140408_120429_185557_2E465577)
Subject: Re: [RFCv2 2/6] mac80211: add new RC API to retrieve expected
 throughput
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 08 Apr 2014 12:04:24 +0200
In-Reply-To: <1396211704-4677-3-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
	 <1396211704-4677-3-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:

> +	u32 (*get_expected_throughput)(void *priv, void *priv_sta,
> +				       struct ieee80211_supported_band *sband);

why would that need an sband argument?

johannes

