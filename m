Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2F2HB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 03:01:58 -0400
Message-ID: <1340953315.4488.2.camel@jlt3.sipsolutions.net> (sfid-20120629_090202_153661_C2630C59)
Subject: Re: [PATCH] mac80211: VHT Cap IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 29 Jun 2012 09:01:55 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D6345@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D6345@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 06:17 +0000, Mahesh Palivela wrote:

> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +							   u32 cap);

Ummmm, Arend was pretty specific... no?

johannes

