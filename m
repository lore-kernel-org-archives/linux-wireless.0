Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50073 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1KLJAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 04:00:13 -0500
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: <j@w1.fi>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wpa_supplicant: Set configured auth_algs
References: <1321023741-32760-1-git-send-email-vthiagar@qca.qualcomm.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 12 Nov 2011 11:00:06 +0200
In-Reply-To: <1321023741-32760-1-git-send-email-vthiagar@qca.qualcomm.com> (Vasanthakumar Thiagarajan's message of "Fri\, 11 Nov 2011 20\:32\:21 +0530")
Message-ID: <877h35af6x.fsf@purkki.adurom.net> (sfid-20111112_100024_534116_340A7DE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com> writes:

> In Ap mode, Authentication algorithm is reset in
> hostapd_config_defaults_bss() and never be set to the configured
> one. This would pass the default auth_algs (OPEN|SHARED) to driver
> and cause authentication isseues.

Shouldn't you send this to the hostap mailing list?

-- 
Kalle Valo
