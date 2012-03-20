Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10725 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2CTInq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 04:43:46 -0400
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4F68433D.2020107@qca.qualcomm.com> (sfid-20120320_094353_580461_3DD0AEE2)
Date: Tue, 20 Mar 2012 10:43:41 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: add debug log for AP MLME operations
References: <1331847371-2213-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1331847371-2213-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 11:36 PM, Aarthi Thiruvengadam wrote:
> This is useful during debugging to check if disconnect commands were issued by
> the host.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied. For some reason the patch was corrupted and I had to
add the code manually. Please check that I didn't do anything wrong.

Kalle
