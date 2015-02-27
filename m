Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35044 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbB0IOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:14:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix usb tx data payload offset issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423840096-14165-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150227081420.30765140041@smtp.codeaurora.org> (sfid-20150227_091423_358857_1393D248)
Date: Fri, 27 Feb 2015 08:14:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Zhaoyang Liu <liuzy@marvell.com>
> 
> Commit 84b313b35f8158d7 ("mwifiex: make tx packet 64 byte DMA aligned")
> induced payload offset issue for USB interface.
> 
> There is no USB interface header for tx packets, so there's no need to
> pull interface length while processing tx skb.
> 
> This patch fixes this issue.
> 
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
