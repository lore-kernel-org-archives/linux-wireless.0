Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52315 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2GKP6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 11:58:12 -0400
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4FFDA28C.1060608@qca.qualcomm.com> (sfid-20120711_175815_777257_F3BD751A)
Date: Wed, 11 Jul 2012 18:58:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: use custom MAC address for newly created interfaces
References: <1341951640-27434-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1341951640-27434-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 11:20 PM, Aarthi Thiruvengadam wrote:
> Firmware and driver generate MAC addresses for the second and third interfaces.
> In addition to the existing algorithm, flip bit 7 of 5th octet. Since both
> firmware and driver individually generate the MAC addresses, introduce a new
> firmware capability bit to keep them compatible.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied. Oddly enough I had conflicts so please check that I
didn't break anything.

Kalle
