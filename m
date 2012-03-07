Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2CGHxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:53:01 -0500
Message-ID: <4F5713D8.5030306@qca.qualcomm.com> (sfid-20120307_085325_733766_5355DC92)
Date: Wed, 7 Mar 2012 09:52:56 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Maintain the listen interval per VIF specific
References: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2012 03:38 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Firmware has the option to support the listen interval
> per vif specific. Fix this.
> 
> Listen interval can be set by the TUs or by the number
> of beacons. Current code enables the user to configure
> the listen interval in the unit of 'number of beacons'
> using debugfs entry "listen_interval". Going forward,
> we need to alter the listen interval in the unit of TUs
> to get good power numbers while going to WOW suspend/resume.
> 
> Allowing the user to change the listen interval in
> the unit of "number of beacons"  in debugfs and changing
> listen interval in wow suspend/resume in the unit of
> time (TUs) would lead us to confuse.
> 
> This patch make sures the listen interval is changed only
> in the unit of time (TUs).
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, both patches applied. For patch 2 I had to do cosmetic changes
because of the new indentation rules.

Kalle
