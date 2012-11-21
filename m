Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36801 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab2KUOzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 09:55:11 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v8 2/4] wireless: allow Atheros card to not depend on ath.ko
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1352978222-13866-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<8206721.qz6ygglX4j@lx-vladimir>
Date: Wed, 21 Nov 2012 16:55:07 +0200
In-Reply-To: <8206721.qz6ygglX4j@lx-vladimir> (Vladimir Kondratiev's message
	of "Wed, 21 Nov 2012 13:18:11 +0200")
Message-ID: <87txsjvwdw.fsf@purkki.adurom.net> (sfid-20121121_155519_512202_92C35387)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> As was discussed, I prepared this patch that address Kconfig issue for the
> Atheros wifi cards.
>
> Any opinions on this?

Looks good to me, but I didn't check that carefully...

Actually I think ath6kl can make use of this as well, it shouldn't
depend anything from ath.ko.

-- 
Kalle Valo
