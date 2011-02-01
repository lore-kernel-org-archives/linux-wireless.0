Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39836 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1BAVSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:18:42 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 02/18] wl1251: fix 4-byte TX buffer alignment
References: <4D45A591.6040600@davizone.at> <4D45B7B8.1060607@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 01 Feb 2011 23:18:39 +0200
In-Reply-To: <4D45B7B8.1060607@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:10\:48 +0100")
Message-ID: <87hbcncv2o.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> This implements TX buffer alignment for cloned or too small skb by
> copying and replacing the original skb.
> Recent changes in wireless-testing seems to make this really necessary.

I have been hit by this as well, thanks for fixing it.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
