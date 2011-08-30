Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44079 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1H3JCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:02:36 -0400
Message-ID: <4E5CA723.4040305@qca.qualcomm.com> (sfid-20110830_110240_917576_118A95E3)
Date: Tue, 30 Aug 2011 12:02:27 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/20] ath6kl: Add functionality for starting AP mode
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> Use cfg80211 add/del_beacon callbacks for starting/stopping AP mode and
> set_beacon to update AP configuration (mainly, to update Beacon and
> Probe Response IEs).

[...]

> +enum wfi_mgmt_frame_type {

Typo? Should it be wmi_mgmt_frame_type?


Kalle
