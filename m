Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22088 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3CJN10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 09:27:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andrei Epure <epure.andrei@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath: changed kmalloc to kmemdup
References: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
Date: Sun, 10 Mar 2013 15:27:20 +0200
In-Reply-To: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
	(Andrei Epure's message of "Sun, 10 Mar 2013 14:39:58 +0200")
Message-ID: <87ehfnfkqv.fsf@kamboji.qca.qualcomm.com> (sfid-20130310_142730_208979_B57D317F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrei Epure <epure.andrei@gmail.com> writes:

> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>

Thanks, I'll take this. But please prefix ath6kl patches with "ath6kl:"
in the future.

-- 
Kalle Valo
