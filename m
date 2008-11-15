Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:44126 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYKOQxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 11:53:43 -0500
To: "Christian Lamparter" <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC][RFT][PATCH] p54: WEP & CCMP accelerator v2
References: <200811141942.50398.chunkeey@web.de>
	<200811150157.45433.chunkeey@web.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 15 Nov 2008 18:53:30 +0200
In-Reply-To: <200811150157.45433.chunkeey@web.de> (ext Christian Lamparter's message of "Sat\, 15 Nov 2008 01\:57\:45 +0100")
Message-ID: <87d4gx7wxh.fsf@nokia.com> (sfid-20081115_175351_881040_CF1ED708)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

> This patch allows p54 to utilize its WEP and CCMP accelerator.
>
> However, I'm not sure how TKIP is supposed to work... Kalle?

Sorry, no idea. I haven't looked at it yet.

-- 
Kalle Valo
