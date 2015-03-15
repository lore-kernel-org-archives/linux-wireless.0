Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58732 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbCOODy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:03:54 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/3] wil6210: re-submit Rx frames to the wireless media if appropriate
Date: Sun, 15 Mar 2015 16:03:42 +0200
Message-ID: <2136800.KgVN8hkJaB@lx-wigig-72> (sfid-20150315_150417_095952_FDA1E16A)
In-Reply-To: <1426428024-4538-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1426428024-4538-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, March 15, 2015 04:00:18 PM Vladimir Kondratiev wrote:
> This is for AP only. If Rx data frame targeted to one of associated clients,
> transmit it back to the wireless media and don't deliver to the host.
> For the multicast frames, deliver to both host and wireless media.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
Please ignore, old patch, sent by mistake.
