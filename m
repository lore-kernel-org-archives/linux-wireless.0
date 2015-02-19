Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbbBSGrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 01:47:37 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 9/9] wil6210: Align Rx buffers on 4*n+2
Date: Thu, 19 Feb 2015 08:47:11 +0200
Message-ID: <2609868.jbmxKLRXsk@lx-wigig-72> (sfid-20150219_075034_713098_4EC8C34C)
In-Reply-To: <1424001758-29529-10-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1424001758-29529-10-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, February 15, 2015 02:02:38 PM Vladimir Kondratiev wrote:
> For the normal (non-sniffer) mode of operation, align Rx buffer
> on 4*n+2, so IP header (after 14 bytes of Ethernet header)
> will start dword aligned. This accelerated IP stack a little bit.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
Kalle,

please do not apply this patch. I found last minute problem with it - 
hardware is not always happy.

For now, drop it please. I will do more testing and re-submit this
patch if everything wends OK.

Thanks, Vladimir
