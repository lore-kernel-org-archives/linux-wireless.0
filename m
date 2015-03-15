Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61112 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbCOOEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:04:11 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 3/3] wil6210: support AP isolation
Date: Sun, 15 Mar 2015 16:03:59 +0200
Message-ID: <1634824.mi1EDKPegN@lx-wigig-72> (sfid-20150315_150417_491851_C8E56D5A)
In-Reply-To: <1426428024-4538-7-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1426428024-4538-7-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, March 15, 2015 04:00:20 PM Vladimir Kondratiev wrote:
> For the AP, configuration may say not to bridge traffic between
> wireless clients. This is conveyed from user space (ex: hostapd has
> ap_isolate parameter) with NL80211_CMD_SET_BSS, to the driver's
> cfg80211 ops method change_bss
> 
> Add support for this setting.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
Please ignore, old patch, sent by mistake.
