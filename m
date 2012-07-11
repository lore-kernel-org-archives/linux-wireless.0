Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20466 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2GKPvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 11:51:10 -0400
Message-ID: <4FFDA0E4.4020209@qca.qualcomm.com> (sfid-20120711_175114_794680_E08B3033)
Date: Wed, 11 Jul 2012 18:51:00 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: support rssi threshold for sched scan
References: <1340308208-4604-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1340308208-4604-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2012 10:50 PM, Thomas Pedersen wrote:
> The ath6kl firmware can filter scan results based on rssi. This is
> useful to limit hosts wakeups on scheduled scans.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
