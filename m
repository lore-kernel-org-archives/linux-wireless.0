Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:55106 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZH0Knj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 06:43:39 -0400
Message-ID: <20090827134340.190465b7qixz4wao@naisho.dyndns.info>
Date: Thu, 27 Aug 2009 13:43:40 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rndis_wlan: increase scan timer delay
References: <20090827073854.27662.68095.stgit@fate.lan>
In-Reply-To: <20090827073854.27662.68095.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please, don't merge this after all. Blocks scan too long and breaks  
NetworkManager/wpa_supplicant.

Quoting "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>:

> Increase scan delay from 1 sec to 6 sec. Spec says that scan by
> OID_802_11_BSSID_LIST_SCAN completes in 6 seconds.
> Before rfkill patch too short delay was not problem as device was
> always active (radio on) and performing background scanning.
>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


