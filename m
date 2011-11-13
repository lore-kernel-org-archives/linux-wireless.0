Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12830 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1KMKez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 05:34:55 -0500
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4EBF9CF8.3050506@qca.qualcomm.com> (sfid-20111113_113458_779645_D47D80E9)
Date: Sun, 13 Nov 2011 12:33:28 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix target minimum length requirement for WMI_SEND_PROBE_RESPONSE_CMDID
References: <1320861956-15533-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1320861956-15533-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 08:05 PM, Aarthi Thiruvengadam wrote:
> The firmware expects the minimum length of
> WMI_SEND_PROBE_RESPONSE_CMDID to be 13. However, when the device is a
> P2P GO and it needs to send a probe response to a non-P2P client,
> there are no P2P IEs to be added, and therefore the length of the WMI
> command is 12. This command gets rejected by the firmware. To fix
> this, add an extra byte to satisfy the minimum length requirement.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied.

Kalle
