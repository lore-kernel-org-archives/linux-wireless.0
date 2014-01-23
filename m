Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26817 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAWM52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:57:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix the printing of 10.x FW version when FW crashed
References: <1390296081-22788-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 23 Jan 2014 14:57:23 +0200
In-Reply-To: <1390296081-22788-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Tue, 21 Jan 2014 17:21:21 +0800")
Message-ID: <87fvoe500c.fsf@kamboji.qca.qualcomm.com> (sfid-20140123_135731_173073_900A5B8D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> 10.x FW has no structure member sw_version_1. Thus,
> both fw_version_release and fw_version_build are not
> available. The provided fw_version_major is also wrong.
> Fix this by using the fw_version from struct wiphy.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Thanks, applied.

-- 
Kalle Valo
