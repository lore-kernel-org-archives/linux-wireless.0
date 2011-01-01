Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48948 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1AAJdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 04:33:32 -0500
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: <linville@tuxdriver.com>, <Jouni.Malinen@Atheros.com>,
	<linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath9k: Reset keycache on resume
References: <1293000612-10884-1-git-send-email-mshajakhan@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 01 Jan 2011 11:33:29 +0200
In-Reply-To: <1293000612-10884-1-git-send-email-mshajakhan@atheros.com> (Mohammed Shafi Shajakhan's message of "Wed\, 22 Dec 2010 12\:20\:12 +0530")
Message-ID: <8762u9ge8m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

a minor nitpick:

Mohammed Shafi Shajakhan <mshajakhan@atheros.com> writes:

> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This means that Mohammed is the author of the patch.

[...]

> Signed-off-by: Jouni Malinen <Jouni.Malinen@Atheros.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

But here the author's sob line should be first one, the order is from
top to bottom. If Mohammed is the author, the sob lines should be
reversed. But if Jouni actually is the author, the From line should be
fixed.

Of course this is just a style issue and doesn't matter that much, but
it's still nice to get it right.

-- 
Kalle Valo
