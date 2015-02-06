Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38448 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbbBFGuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:50:07 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: Delete an unnecessary check before the function
 call"relay_close"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <54D25CDC.3040405@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20150206065007.0E82D140CC9@smtp.codeaurora.org> (sfid-20150206_075051_337622_980114A8)
Date: Fri,  6 Feb 2015 06:50:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 4 Feb 2015 18:48:28 +0100
> 
> The relay_close() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
