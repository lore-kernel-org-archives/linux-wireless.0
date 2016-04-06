Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcDFSmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:42:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v6] rt2x00usb: Use usb anchor to manage URB
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458384061-22522-1-git-send-email-vishalthanki@gmail.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	linux-wireless@vger.kernel.org,
	Vishal Thanki <vishalthanki@gmail.com>
Message-Id: <20160406184210.9FC65615CF@smtp.codeaurora.org> (sfid-20160406_204215_662332_1DD0B733)
Date: Wed,  6 Apr 2016 18:42:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> With current driver, it is observed that a URB is not
> completed while the USB disconnect is initiated. Due to
> that, the URB completion handler is trying to access
> the resource which was freed as a part of USB disconnect.
> Managing the URBs with anchor will make sure that all
> the URBs are handled gracefully before device gets
> disconnected.
> 
> Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
