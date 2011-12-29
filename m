Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33018 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1L2NM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 08:12:59 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Paul Stewart <pstew@google.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] mac80211: use RCU read locks for sta_info_get
References: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Thu, 29 Dec 2011 15:12:49 +0200
In-Reply-To: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Mon, 26 Dec 2011 12:29:38
	+0530")
Message-ID: <87mxabcyi6.fsf@purkki.adurom.net> (sfid-20111229_141303_642067_BF19BD99)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

A bit more background would be nice. What user visible bug this actually
fixes? Is this a new regression or an old bug? If the former, what
commit introduced the regression?

-- 
Kalle Valo
