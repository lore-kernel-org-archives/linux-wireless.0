Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4979 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2AXLqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:46:38 -0500
Message-ID: <4F1E9A19.7080406@qca.qualcomm.com> (sfid-20120124_124642_199102_E994D733)
Date: Tue, 24 Jan 2012 13:46:33 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 7/8] ath6kl: Add a support to handle the host sleep
 mode cmd processed event
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-8-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-8-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> For every WMI_SET_HOST_SLEEP_MODE_CMDID command (send from the host),
> the firmware sends WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID as
> an acknowledgement to the host.
> 
> In order to being sync with the firmware, the host has to wait for
> this event before going to the suspend state.
> 
> This patch adds,
>  * New command WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID in
>    WMI event table.
>  * New WMI function ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx()
>    to process the event.
>  * New flag HOST_SLEEP_MODE_CMD_PROCESSED in VIF flags to record
>    the arrival of the event.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

You could fold patches 7 and 8 as they are one logical change.

Kalle
