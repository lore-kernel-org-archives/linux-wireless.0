Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36442 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1AaPnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:43:39 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 11/18] wl1251: configure hardware en-/decryption for monitor mode
References: <4D45A5DE.70507@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 17:43:37 +0200
In-Reply-To: <4D45A5DE.70507@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:54\:38 +0100")
Message-ID: <87ipx5dqom.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
> (DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
> present.

Why? To be able to receive encrypted frames when associated or
something else?

-- 
Kalle Valo
