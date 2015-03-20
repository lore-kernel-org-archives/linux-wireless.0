Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51466 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbCTGhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 02:37:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/7] wil6210: optimize index manipulation in wil_vring_reap_rx
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426428024-4538-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-Id: <20150320063706.513C2140BC6@smtp.codeaurora.org> (sfid-20150320_073712_632133_E597B48F)
Date: Fri, 20 Mar 2015 06:37:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Use temporal variable for often used vring->swhead;
> and use proper index in debug printing - vring->swhead
> used before was modified in wil_vring_advance_head
> and then increased value was used in debug print
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

148416a973e0 wil6210: optimize index manipulation in wil_vring_reap_rx
cec94d8cf5c2 wil6210: fix check for FW responsiveness
c406ea7c7406 wil6210: Align Rx frames on 4*n+2 by having SNAP
a82553bb9035 wil6210: Prefer ether_addr_copy() over memcpy()
62bfd30031fa wil6210: add bcast structures to WMI
41d6b093b7f8 wil6210: implement broadcast/multicast data
70812421fb15 wil6210: fall back to pseudo-DMS mcast for secure link and PBSS

Kalle Valo
