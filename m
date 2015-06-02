Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43221 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbFBNkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 09:40:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>
Subject: Re: [PATCHv4 00/17] mwifiex patches
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
Date: Tue, 02 Jun 2015 16:40:01 +0300
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Mon, 1 Jun 2015 23:31:58 +0530")
Message-ID: <874mmqut3i.fsf@kamboji.qca.qualcomm.com> (sfid-20150602_154015_199268_A3782F22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> This patch series mainly adds enhancements for mwifiex AP. 
> With this series, we support verbose information in station dump command
> also information about AP link.
> Another important enhancement is related to parsing IEs from tail of beacondata.
> Few issues seen during DFS testing are also fixed in this series.

When you send a new version of a patch or patchset, please add a
changelog so that people don't have to guess what has changed since
previous version. For example, this cover letter is a good place to add
it. You can find lots of examples from the mailing list archives.

-- 
Kalle Valo
