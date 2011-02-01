Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39526 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1BAWYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:24:01 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 06/18] wl1251: enable beacon early termination while in power-saving mode
References: <4D45A5B7.9010203@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:23:59 +0200
In-Reply-To: <4D45A5B7.9010203@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:53\:59 +0100")
Message-ID: <874o8ncs1s.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Port the beacon early termination feature from wl1251 driver version
> included in the Maemo Fremantle kernel. It is enabled when going to
> power-saving mode and disabled when leaving power-saving mode.

Looks good to me.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
