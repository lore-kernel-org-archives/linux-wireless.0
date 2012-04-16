Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53367 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2DPMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 08:31:25 -0400
Message-ID: <4F8C1118.3000605@qca.qualcomm.com> (sfid-20120416_143129_991402_81B2B0B8)
Date: Mon, 16 Apr 2012 15:31:20 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Subramania Sharma Thandaveswaran <sharmat@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix bug in bg scan configuration in schedule
 scan
References: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com> <1334572797-6561-2-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1334572797-6561-2-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 01:39 PM, rmani@qca.qualcomm.com wrote:
> From: Subramania Sharma Thandaveswaran <sharmat@qca.qualcomm.com>
> 
> Background scan interval should not be modified while starting
> schedule scanning, use the currently configured one instead.
> 
> Signed-off-by: Subramania Sharma <sharmat@qca.qualcomm.com>

This should really describe the bug more verbosely, but this time I can
add that when I commit the patch.

Kalle
