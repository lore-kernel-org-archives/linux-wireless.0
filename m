Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33745 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab1BHKF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 05:05:28 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 14/18] wl1251: implement multicast address filtering
References: <4D45A5F4.5080800@davizone.at> <4D45B7D3.90707@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 12:05:26 +0200
In-Reply-To: <4D45B7D3.90707@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:11\:15 +0100")
Message-ID: <87ei7i96zd.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Port multicast address filtering from wl1271 driver.
> It sets up the hardware multicast address filter in configure_filter() with
> addresses supplied through prepare_multicast().

Thanks, looks good to me.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
