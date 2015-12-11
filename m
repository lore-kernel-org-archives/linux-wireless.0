Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbLKLPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:15:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: cw1200: remove some dead code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151204131523.GB12792@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20151211111531.630D3141A67@smtp.codeaurora.org> (sfid-20151211_121536_862307_04DE7041)
Date: Fri, 11 Dec 2015 11:15:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If the mode is NL80211_IFTYPE_UNSPECIFIED then we return success at the
> start of the function so this condition is never true.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
