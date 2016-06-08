Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64020 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945942AbcFHOYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 10:24:44 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	Linux Kernel <prasunmaii87@gmail.com>
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
Date: Wed, 8 Jun 2016 14:23:47 +0000
Message-ID: <87wplzkbd9.fsf@kamboji.qca.qualcomm.com> (sfid-20160608_162510_428783_EE57D14F)
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
In-Reply-To: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
	(Prasun Maiti's message of "Wed, 8 Jun 2016 17:51:14 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> writes:

> Since add more warnings for inconsistent ops in cfg80211, the wireless
> core warns if a driver implements a cfg80211 callback but doesn't
> implements the inverse operation. The ath6kl driver implements a cfg80211
> .get_antenna operation handler but doesn't have the inverse .set_antenna
> callback. So, it makes warning.
>
> To remove this warning, add .set_antenna callback in ath6kl driver and
> also send a cmd to firmware with it's values.
>
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>

Did you test this? What hardware and firmware version?

-- 
Kalle Valo