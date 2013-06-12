Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43498 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab3FLHPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 03:15:54 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH] mwifiex: Add module parameter for regdomain
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
Date: Wed, 12 Jun 2013 10:15:49 +0300
In-Reply-To: <1370904007-10959-1-git-send-email-bzhao@marvell.com> (Bing
	Zhao's message of "Mon, 10 Jun 2013 15:40:07 -0700")
Message-ID: <877ghz3il6.fsf@purkki.adurom.net> (sfid-20130612_091602_161340_70245017)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

> From: Avinash Patil <patila@marvell.com>
>
> Allow a regulatory domain country code to be specified at boot
> using a module argument.  This overrides the firmware regulatory
> mode.
>
> This patch also enables uAP to operate in 11a mode with hostapd.
>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

This looks ugly. Why can't you use the proper nl80211 interface and
instead want to add a driver specific hack?

-- 
Kalle Valo
