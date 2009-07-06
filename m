Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49653
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbZGFVgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 17:36:18 -0400
Date: Mon, 06 Jul 2009 14:36:24 -0700 (PDT)
Message-Id: <20090706.143624.182421767.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A5261AE.1010500@lwfinger.net>
References: <4A5253F1.50504@lwfinger.net>
	<20090706.125011.56653570.davem@davemloft.net>
	<4A5261AE.1010500@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 06 Jul 2009 15:42:22 -0500

> This patch fixes my USB device.

Thanks for testing.

> Please push to Linus.

Will do.
