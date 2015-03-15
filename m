Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19949 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbCOODf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:03:35 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 1/3] wil6210: NAPI completion refactor
Date: Sun, 15 Mar 2015 16:03:23 +0200
Message-ID: <2054086.3egRf2SmyA@lx-wigig-72> (sfid-20150315_150417_279751_A76089E6)
In-Reply-To: <1426428024-4538-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1426428024-4538-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, March 15, 2015 04:00:15 PM Vladimir Kondratiev wrote:
> t is expected that driver completes NAPI when less than
> full budget is consumed.
> 
> Fulfill this requirement.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
Please ignore, old patch, sent by mistake.
