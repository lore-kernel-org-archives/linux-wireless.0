Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48801 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2CAGip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:38:45 -0500
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4F4F196F.1000100@qca.qualcomm.com> (sfid-20120301_073848_273989_68FD6AAC)
Date: Thu, 1 Mar 2012 08:38:39 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Clear the IE in firmware if not set
References: <1330449424-4975-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1330449424-4975-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 07:17 PM, Aarthi Thiruvengadam wrote:
> Remove check so that IE in firmware is cleared if not set. Without this fix, any
> previously set IE will be used incorrectly in the next frame. For example,
> consider the scenario where a P2P device scan is followed by a regular station
> scan. The P2P IE set by the P2P scan needs to be cleared, otherwise the station
> scan will contain the P2P IE.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied.

Kalle
