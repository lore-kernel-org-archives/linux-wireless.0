Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10997 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2DIPe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 11:34:26 -0400
Message-ID: <4F830176.1060604@qca.qualcomm.com> (sfid-20120409_173429_464425_62215FC3)
Date: Mon, 9 Apr 2012 18:34:14 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Subramania Sharma <sharmat@qca.qualcomm.com>
Subject: Re: [PATCH V2] ath6kl: Fix 4-way handshake failure in AP and P2P
 GO mode
References: <\> <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2012 06:21 PM, Vasanthakumar Thiagarajan wrote:
> RSN capability field of RSN IE which is generated (which is what really
> advertised in beacon/probe response) differs from the one generated in
> wpa_supplicant. This inconsistency in rsn IE results in 4-way handshake
> failure. To fix this, configure rsn capability used in wpa_supplicant
> in firmware using a new wmi command, WMI_SET_IE_CMDID. There is a bit
> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) in fw_capabilities to advertise
> this support to driver.
> 
> Signed-off-by: Subramania Sharma <sharmat@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied. But there were conflicts, please check that I didn't
break anything.

Kalle
