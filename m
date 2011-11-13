Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1KMJEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 04:04:55 -0500
Message-ID: <4EBF8803.6020906@qca.qualcomm.com> (sfid-20111113_100530_433017_ACE13CDF)
Date: Sun, 13 Nov 2011 11:04:03 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath6kl: Add support for WAPI configuration
References: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 11:39 AM, Jouni Malinen wrote:
> This set of patches extends ath6kl to allow station and AP mode WAPI
> support to be enabled. Please note that these depend on earlier patches
> that are not yet in wireless-testing.git:
> 
> ieee80211: Define cipher suite selector for WPI-SMS4
> nl80211: Increase maximum NL80211_ATTR_KEY_SEQ length to 16
> 
> In addition, the three patches I sent yesterday for ath6kl should be
> applied first:
> 
> ath6kl: Remove unused WMI crypto defines
> ath6kl: Fix key configuration to copy at most seq_len from seq
> ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values

Thanks, all three applied.

Kalle
