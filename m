Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64775 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2FKNHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:07:41 -0400
Message-ID: <4FD5ED97.3020505@qca.qualcomm.com> (sfid-20120611_150744_613008_8C5A1546)
Date: Mon, 11 Jun 2012 16:07:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Etay Luz <eluz@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add missing newline terminations
References: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com>  <1338365645.28696.0.camel@joe2Laptop> <4FC5D73A.9040807@qca.qualcomm.com> <1338368319.28696.3.camel@joe2Laptop>
In-Reply-To: <1338368319.28696.3.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 11:58 AM, Joe Perches wrote:
> Messages without newlines can be interleaved.
> Avoid this by adding terminations.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, applied.

Kalle
