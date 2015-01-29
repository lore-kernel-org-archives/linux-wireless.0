Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56083 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbA2IVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 03:21:18 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/8] mwifiex: remove redundant nick_name variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422439925-25666-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, Avinash Patil <patila@marvell.com>
Message-Id: <20150129082118.2F76E13FEF0@smtp.codeaurora.org> (sfid-20150129_092125_047418_508FB73C)
Date: Thu, 29 Jan 2015 08:21:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is not used anywhere execpt initialization.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

e52a85d383d5 mwifiex: remove redundant nick_name variable
09f63ae65f90 mwifiex: set wiphy params only once
4facc34a1f1d mwifiex: do not declare wdev as pointer
8d05eb222074 mwifiex: store permanant mac address in adapter structure
1247cc1f4390 mwifiex: add init parameter to init command routine
cf0523350c6f mwifiex: manage virtual interface limits efficiently
76c504ca1e7d mwifiex: handle PS events on AP interface as well
047eaaf64503 mwifiex: support conversion to any virtual interface type

Kalle Valo
