Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35305 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbLaIYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:24:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: prism54: fix checks for dma mapping errors
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451083361-13141-1-git-send-email-khoroshilov@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Message-Id: <20151231082407.F20E76034E@smtp.codeaurora.org> (sfid-20151231_092431_471370_8A84B2F3)
Date: Thu, 31 Dec 2015 08:24:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> prism54 checks for dma mapping errors by comparison returned address
> with zero, while pci_dma_mapping_error() should be used.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
