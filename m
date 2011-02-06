Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:43001 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1BFOFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 09:05:02 -0500
Message-ID: <4D4EAA86.5010408@davizone.at>
Date: Sun, 06 Feb 2011 15:04:54 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 05/18] wl1251: retry power save entry
References: <4D45A5AD.4010402@davizone.at> <878vxzcsbh.fsf@purkki.adurom.net>
In-Reply-To: <878vxzcsbh.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-02-01 23:18, schrieb Kalle Valo:
> If firmware fails to send the nullfunc frame, something is wrong with
> the connection and we should notify about this to mac80211. At least
> wl12xx uses ieee80211_connection_loss(), maybe that's the best option
> here?

Yes, I will add that.
