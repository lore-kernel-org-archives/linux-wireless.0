Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36582 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1BAWgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:36:14 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 12/18] wl1251: set rate index and preamble flag on received packets
References: <4D45A5E7.1040202@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:36:12 +0200
In-Reply-To: <4D45A5E7.1040202@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:54\:47 +0100")
Message-ID: <87k4hjbcwz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Set the rate index rate_idx and preamble flag RX_FLAG_SHORTPRE on received
> packets.
>
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
