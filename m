Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54575 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab0BGSma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 13:42:30 -0500
Received: by wwi18 with SMTP id 18so1394226wwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 10:42:29 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 1/2] b43: remove get_tx_stats() mac80211 op
References: <87d40hhtc5.fsf@purkki.valot.fi>
	<20100207175050.8553.90786.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 07 Feb 2010 20:42:26 +0200
In-Reply-To: <20100207175050.8553.90786.stgit@tikku> (Kalle Valo's message of "Sun\, 07 Feb 2010 19\:50\:50 +0200")
Message-ID: <87zl3khoq5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> get_tx_stats() will be removed from mac80211.
>
> Compile-tested only.

This patch replaces patch 5 from the remove get_tx_stats() patchset.

-- 
Kalle Valo
