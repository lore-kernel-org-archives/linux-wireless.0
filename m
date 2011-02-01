Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39533 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1BAW0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:26:22 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 07/18] wl1251: implement connection quality monitoring
References: <4D45A5C1.8050503@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:26:19 +0200
In-Reply-To: <4D45A5C1.8050503@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:54\:09 +0100")
Message-ID: <87zkqfbddg.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Implement connection quality monitoring similar to the wl1271 driver.
> It triggers ieee80211_cqm_rssi_notify with the corresponding event when
> RSSI drops blow RSSI threshold or rises again above the RSSI threshold.
> It should be noted that wl1251 doesn't support RSSI hysteresis, instead it
> uses RSSI averageing and delays events until a certain count of frames
> proved RSSI change.

Had a quick look and no problems with this one.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
