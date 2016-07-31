Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbcGaMDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 08:03:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mwifiex: remove superfluous condition (2)
References: <1469962177-2432-1-git-send-email-xypron.glpk@gmx.de>
Date: Sun, 31 Jul 2016 15:03:03 +0300
In-Reply-To: <1469962177-2432-1-git-send-email-xypron.glpk@gmx.de> (Heinrich
	Schuchardt's message of "Sun, 31 Jul 2016 12:49:37 +0200")
Message-ID: <877fc2816w.fsf@purkki.adurom.net> (sfid-20160731_140411_441297_CEE23E1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> writes:

> We are using mac as source address in a memcpy.
> In the lines below we can assume mac is not NULL.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Please try to make the commit titles unique, for example you can use
function names or something else. Adding "(2)" is not the way to do
that.

-- 
Kalle Valo
