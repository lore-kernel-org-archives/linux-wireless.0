Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45608 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1BHJ4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 04:56:55 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 13/18] wl1251: rework configure_filter() callback
References: <4D45A5EE.6040108@davizone.at> <4D45B7D1.5030005@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 11:56:51 +0200
In-Reply-To: <4D45B7D1.5030005@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:11\:13 +0100")
Message-ID: <87ipwu97do.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> The configure_filter() callback function no longer needs to be atomic.
> Remove the scheduled work structure and call firmware functions directly.
> Add filter support for monitor mode and fix flag mapping for
> FIF_PROMISC_IN_BSS and FIF_OTHER_BSS.
> Fix BSSID filter config for changed BSSID handling since commit 9cef8737
> "mac80211: fix managed mode BSSID handling" and remove workaround.

Thanks, looks good to me.

> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
