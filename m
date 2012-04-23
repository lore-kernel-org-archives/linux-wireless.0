Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39801 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2DWL3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:24 -0400
Message-ID: <4F953D00.8010900@qca.qualcomm.com> (sfid-20120423_132927_500754_1146146D)
Date: Mon, 23 Apr 2012 14:29:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath6kl: support fw reporting phy capabilities
References: <1334874717-7431-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1334874717-7431-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 01:31 AM, Thomas Pedersen wrote:
> Currently the supported bands are just hard coded in the driver.
> However, the ath6kl FW will include its 11n and band capabilites in a
> WMI_READY event. Handle this and report capabilites to cfg80211
> accordingly.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
