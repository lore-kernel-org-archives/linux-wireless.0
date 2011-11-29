Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41971 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1K2GgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 01:36:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] wireless: fix set tx power
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Date: Tue, 29 Nov 2011 08:36:06 +0200
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com> (Luis
	R. Rodriguez's message of "Mon, 28 Nov 2011 16:38:45 -0500")
Message-ID: <877h2jh1ux.fsf@purkki.adurom.net> (sfid-20111129_073613_961718_A1308DD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com> writes:

> The driver maintainers have approved of these now except for brcm80211.
> I should note that Kalle indicated he was going to queue up the ath6kl
> patch though so not sure if you want to wait for his patch or just suck
> mine in.

John, please don't take the ath6kl patch as it's already in ath6kl.git:

https://github.com/kvalo/ath6kl/commit/b992a28557afdcabcee7d8af88471dddfe791c11

> I think it makes sense to roll these in together as a series,

I don't see any benefit from this.

> the rebase that Kalle would do shouldn't be impacted by this I think.

I don't rebase ath6kl.git unless absolutely necessary. And I prefer that
ath6kl patches would go through ath6kl.git, I get less conflicts that
way.

-- 
Kalle Valo
