Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31520 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbcGSR6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 13:58:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: sme_state shortcut to SME_DISCONNECTED removed
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1468026259-25148-1-git-send-email-dan.kephart@lairdtech.com>
To: <engineering@keppy.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <6391652757ff480fb11a6019d47f5e49@eusanexr01a.eu.qualcomm.com> (sfid-20160719_195857_884467_DC3542E3)
Date: Tue, 19 Jul 2016 10:56:48 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

engineering@keppy.com wrote:
> From: Dan Kephart <dan.kephart@lairdtech.com>
> 
> When an NL80211_DISCONNECT is sent to cfg80211, the driver's cfg80211
> disconnect function sets the sme_state to SME_DISCONNECTED before receiving
> a WMI_DISCONNECT_EVENT from the firmware.  This caused cfg80211 to not know
> that the connection is disconnected because the driver fails to notify
> cfg80211 upon receiving WMI_DISCONNECT_EVENT from the firmware believing
> it is already disconnected.
> 
> Signed-off-by: Dan Kephart <dan.kephart@lairdtech.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

42e54152e707 ath6kl: sme_state shortcut to SME_DISCONNECTED removed

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9221927/

