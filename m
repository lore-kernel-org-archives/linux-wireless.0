Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46102 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2CAGoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:44:08 -0500
Message-ID: <4F4F1AB3.7070602@qca.qualcomm.com> (sfid-20120301_074412_129818_1A6DB307)
Date: Thu, 1 Mar 2012 08:44:03 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Etay Luz <eluz@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: add padding to firmware log records
References: <1330478235-29294-1-git-send-email-eluz@qca.qualcomm.com>
In-Reply-To: <1330478235-29294-1-git-send-email-eluz@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 03:17 AM, Etay Luz wrote:
> firmware debug utility expects firmware log record size
> to be 1500 bytes. This patch ensures that the
> firmware record will be exactly 1500 bytes.
> 
> Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>

Thanks, applied.

Kalle
