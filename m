Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57903 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbbGUNoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:44:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [5/6] wireless: cw1200: Remove redundant spi driver bus
 initialization
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435071185-24586-1-git-send-email-borneo.antonio@gmail.com>
To: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Antonio Borneo <borneo.antonio@gmail.com>,
	linux-kernel@vger.kernel.org
Message-Id: <20150721134407.E2E6E141061@smtp.codeaurora.org> (sfid-20150721_154448_460707_8290D42A)
Date: Tue, 21 Jul 2015 13:44:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In ancient times it was necessary to manually initialize the bus
> field of an spi_driver to spi_bus_type. These days this is done in
> spi_register_driver(), so we can drop the manual assignment.
> 
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> To: Solomon Peachy <pizza@shaftnet.org>
> To: Kalle Valo <kvalo@codeaurora.org>
> To: linux-wireless@vger.kernel.org
> To: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
