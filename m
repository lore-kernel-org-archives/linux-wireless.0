Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6236 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2DPGjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:39:47 -0400
Message-ID: <4F8BBEAD.40305@qca.qualcomm.com> (sfid-20120416_084006_290334_043BD408)
Date: Mon, 16 Apr 2012 09:39:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH linux-next 1/1] ath6k: Normalize use of FW_DIR
References: <1334337448-26270-1-git-send-email-tim.gardner@canonical.com> <1334337448-26270-2-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1334337448-26270-2-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2012 08:17 PM, Tim Gardner wrote:
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Thanks, applied to ath6kl.git. But ar6004 hw1.2 supports wasn't in
linux-next yet so I changed it as well. If you can, please check my changes:

https://github.com/kvalo/ath6kl/commit/2023dbb8310ab39ac1119a32ef52405f7a73f51f

Kalle
