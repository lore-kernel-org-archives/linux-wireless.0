Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:1271 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139Ab0HKSnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:43:23 -0400
Message-ID: <4C62EF48.4080804@gmail.com>
Date: Wed, 11 Aug 2010 20:43:20 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/5] mac80211: use cipher suite selectors
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From: Johannes Berg <johannes.berg@intel.com>
>
>Currently, mac80211 translates the cfg80211
>cipher suite selectors into ALG_* values.
>That isn't all too useful, and some drivers
>benefit from the distinction between WEP40
>and WEP104 as well. Therefore, convert it
>all to use the cipher suite selectors.
>
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>

For the rt2x00 parts:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan.
