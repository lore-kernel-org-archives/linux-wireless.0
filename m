Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60949 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbcC3Lvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 07:51:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] wireless: ti: Convert specialized logging macros to kernel style
References: <cover.1457395071.git.joe@perches.com>
Date: Wed, 30 Mar 2016 14:51:49 +0300
In-Reply-To: <cover.1457395071.git.joe@perches.com> (Joe Perches's message of
	"Mon, 7 Mar 2016 16:19:32 -0800")
Message-ID: <87shz85gkq.fsf@purkki.adurom.net> (sfid-20160330_135222_837116_3B590534)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> Using the normal kernel logging mechanisms makes this code
> a bit more like other wireless drivers.

Personally I don't see the point but I don't have any strong opinions. A
bigger problem is that TI drivers are not really in active development
and that's I'm not thrilled to take big patches like this for dormant
drivers.

-- 
Kalle Valo
