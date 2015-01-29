Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54863 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbA2H43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 02:56:29 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/10] wil6210: sync WMI with firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422175971-8075-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-Id: <20150129075628.390A61411A4@smtp.codeaurora.org> (sfid-20150129_085632_316703_94D9948D)
Date: Thu, 29 Jan 2015 07:56:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Incorporate changes from firmware.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, 10 patches applied to wireless-drivers-next.git:

8c6796758f0a wil6210: sync WMI with firmware
c5e96c91fa8f wil6210: fix timing of netif_carrier_on indication
32a20d46b3dc wil6210: ignore firmware failure to gracefully stop AP
f1871cd95067 wil6210: Add Tx queue len configuration
3baedd9167c2 wil6210: tuning rings size
918465a3c2f7 wil6210: interrupt moderation configuration update
1f80af2e38f7 wil6210: remove unnecessary interrupt moderation module parameters
713c8a29e4d8 wil6210: implement skb Tx status reporting
40822a901e3c wil6210: implement cfg80211 probe_client() op
382afc3d055b wil6210: move Rx reorder buffer allocation out of spinlock

Kalle Valo
