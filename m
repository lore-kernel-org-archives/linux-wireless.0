Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44721 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbCMNSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:18:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] wil6210: NAPI completion refactor
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425822123-24668-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-Id: <20150313131820.E066E140CF8@smtp.codeaurora.org> (sfid-20150313_141823_989844_933F2AF6)
Date: Fri, 13 Mar 2015 13:18:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> It is expected that driver completes NAPI when less than
> full budget is consumed.
> 
> Fulfill this requirement.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

7308a20e7579 wil6210: NAPI completion refactor
c42da9993a4c wil6210: re-submit Rx frames to the wireless media if appropriate
02beaf1a5b8f wil6210: support AP isolation

Kalle Valo
