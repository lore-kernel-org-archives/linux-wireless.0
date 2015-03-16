Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935403AbbCPQEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:04:48 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: fix a bug in Rx multiport aggregation logic
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426148971-6103-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150316160448.15A0213FAA0@smtp.codeaurora.org> (sfid-20150316_170452_216995_5B6DFED2)
Date: Mon, 16 Mar 2015 16:04:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Cathy Luo <cluo@marvell.com>
> 
> It's been observed Rx aggregated packets are always followed
> by a single Rx packet. This patch improves our logic to add
> that extra packet in next aggregation.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
