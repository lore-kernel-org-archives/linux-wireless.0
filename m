Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44814 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbbKZNFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:05:38 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] libertas: check for NULL before use
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1448353298-16110-1-git-send-email-sudipm.mukherjee@gmail.com>
To: sudip <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Message-Id: <20151126130538.0263F14077A@smtp.codeaurora.org> (sfid-20151126_140558_083870_90CBE32B)
Date: Thu, 26 Nov 2015 13:05:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If kzalloc fails it will return NULL. Lets check for NULL first before
> using the pointer.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
