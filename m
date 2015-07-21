Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39409 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbbGUPKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:10:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/3] mwifiex: add bss mode TLV to extended scan command
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437059123-19477-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150721151018.D99FC141C14@smtp.codeaurora.org> (sfid-20150721_171022_753120_929A2E01)
Date: Tue, 21 Jul 2015 15:10:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Aniket Nagarnaik <aniketn@marvell.com>
> 
> We are setting BSS mode as ANY so that firmware will provide
> all types of scan entries.
> 
> Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

40d7412b56f0 mwifiex: add bss mode TLV to extended scan command
0c6303cc0695 mwifiex: use maximum ssid length as 0xfe for p2p
e79801ffe9c8 mwifiex: correct p2p and station interface counters

Kalle Valo
