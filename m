Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35166 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2GQGQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 02:16:09 -0400
Message-ID: <50050324.2090001@qca.qualcomm.com> (sfid-20120717_081613_670065_A220900A)
Date: Tue, 17 Jul 2012 09:16:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Add support for AR6004 chipset.
References: <1342505284-12315-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1342505284-12315-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2012 09:08 AM, Bala Shanmugam wrote:
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

Change the title as it's misleading. ath6kl already has ar6004, you are
just adding hw1.3 support.

And please write something in the commit log, like:

"Add support for AR6004 hardware version 1.3 which has id 0x31c8088a."

Otherwise looks good to me.

Kalle
