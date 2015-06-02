Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48543 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbFBUcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 16:32:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ray_cs: Change 1 to true for bool type variable.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432688157-2678-1-git-send-email-shailendra.capricorn@gmail.com>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shailendra Verma <shailendra.capricorn@gmail.com>
Message-Id: <20150602203246.B24AD1402DA@smtp.codeaurora.org> (sfid-20150602_223250_817225_94B046BF)
Date: Tue,  2 Jun 2015 20:32:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The variable translate is bool type. So assigning true instead of 1.
> 
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
