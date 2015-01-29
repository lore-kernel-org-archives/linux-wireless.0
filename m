Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17546 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbA2K0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 05:26:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Enable the MCS8 and MCS9 at 2.4G band
References: <1421972300-23520-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Thu, 29 Jan 2015 12:25:58 +0200
In-Reply-To: <1421972300-23520-1-git-send-email-yanbol@qca.qualcomm.com>
	(Yanbo Li's message of "Fri, 23 Jan 2015 08:18:20 +0800")
Message-ID: <87r3ud3mtl.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_112621_143643_F9AD4FAE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> From: Yanbo Li <yanbol@qti.qualcomm.com>
>
> Enable the MCS8 and MCS9 support for 2.4G band, it will
> use these data rate with other devices having the same
> capability.
>
> Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
