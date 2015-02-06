Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38416 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbBFGtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:49:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] cw1200: Delete an unnecessary check before the function
 call "release_firmware"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <54D24D1F.50001@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Solomon Peachy <pizza@shaftnet.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20150206064901.1EFAE140CB9@smtp.codeaurora.org> (sfid-20150206_074935_276213_BE3A084C)
Date: Fri,  6 Feb 2015 06:49:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 4 Feb 2015 16:32:15 +0100
> 
> The release_firmware() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks, 2 patches applied to wireless-drivers-next.git:

df970d39b90e cw1200: Delete an unnecessary check before the function call "release_firmware"
ee4ddad82356 cw1200: Less function calls in cw1200_load_firmware_cw1200() after error detection

Kalle Valo
