Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52231 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966185Ab2EPNYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 09:24:15 -0400
Message-ID: <4FB3AA74.3070305@qca.qualcomm.com> (sfid-20120516_152419_644003_0FF3FC4E)
Date: Wed, 16 May 2012 16:24:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: enable enhanced bmiss detection
References: <1337065763-2554-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1337065763-2554-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 10:09 AM, Thomas Pedersen wrote:
> Enable enhanced bmiss detection if the firmware supports it. This
> feature is only enabled on some firmwares since it comes with a power
> cost.
> 
> Also add a few missing command ids to keep the enums straight.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied. There was a one compiler warning with ath6kl_err(), I
amended a fix for that.

Kalle
