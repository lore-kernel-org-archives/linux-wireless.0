Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23729 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2DIOue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 10:50:34 -0400
Message-ID: <4F82F735.1070505@qca.qualcomm.com> (sfid-20120409_165037_871326_B77D8D45)
Date: Mon, 9 Apr 2012 17:50:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2] ath6kl: Fix target assert in p2p bringup with multi
 vif
References: <1333724070-17603-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1333724070-17603-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2012 05:54 PM, Vasanthakumar Thiagarajan wrote:
> Using interface 0 for p2p causes target assert. This is because
> interface 0 is always initialized to non-p2p operations. Fix this
> issue by initializing all the interfaces for p2p when fw is capable
> of dynamic interface switching. When fw is not capable of dynamic
> switching, make sure p2p is not brought up on interface which is
> not initialized for this purpose.
> 
> Reported-by: Naveen Singh navesing@qca.qualcomm.com
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
