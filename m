Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58521 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2DRKFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 06:05:24 -0400
Message-ID: <4F8E91DF.2000102@qca.qualcomm.com> (sfid-20120418_120528_076669_9B1769B4)
Date: Wed, 18 Apr 2012 13:05:19 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Retain bg scan period value modified by the
 user
References: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 01:39 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Added a new member bg_scan_period in struct ath6kl_vif
> to retain background scan period value configured via debugfs
> entry 'bgscan_interval'. This backup is needed in schedule scan
> path while configuring scan parameters.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, both patches applied. But I did minor improvements to the commit
log in patch 2.

Kalle
