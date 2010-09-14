Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41381 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0INNfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 09:35:05 -0400
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Enable fastcc for HTC devices.
References: <1283497888-8294-1-git-send-email-rmanoharan@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Sep 2010 16:35:02 +0300
In-Reply-To: <1283497888-8294-1-git-send-email-rmanoharan@atheros.com> (Rajkumar Manoharan's message of "Fri\, 3 Sep 2010 12\:41\:28 +0530")
Message-ID: <87zkvk5tyx.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanoharan@atheros.com> writes:

> By enabling fastcc, the scan time reduced to half.

It helps the users if a patch like this describes what fastcc really
is and why it reduces the scan time. And what might be the side
effects. This is valuable information especially when someone is
debugging regressions. So please try to be as informative as possible,
especially when enabling new features.

For example, I have no idea what fastcc means. Fast C Compiler? ;)

-- 
Kalle Valo
