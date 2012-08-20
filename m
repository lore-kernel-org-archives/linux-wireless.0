Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52419 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 03:09:35 -0400
Message-ID: <5031E2AA.5050605@qca.qualcomm.com> (sfid-20120820_090938_856727_DD090420)
Date: Mon, 20 Aug 2012 10:09:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: protect firmware from excessive WoW pattern length
References: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 03:15 AM, Thomas Pedersen wrote:
> Don't accept WoW patterns longer than supported by firmware.
> 
> Reported-by: Haijun Jin <nhjin@qca.qualcomm.com>
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
