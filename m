Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49647
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZGFVgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 17:36:00 -0400
Date: Mon, 06 Jul 2009 14:36:06 -0700 (PDT)
Message-Id: <20090706.143606.09407511.davem@davemloft.net>
To: gurligebis@gmail.com
Cc: Larry.Finger@lwfinger.net, chunkeey@web.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c30dffe0907061326n77823e03lf87f4feb616c8f7b@mail.gmail.com>
References: <4A5253F1.50504@lwfinger.net>
	<20090706.125011.56653570.davem@davemloft.net>
	<9c30dffe0907061326n77823e03lf87f4feb616c8f7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
Date: Mon, 6 Jul 2009 22:26:09 +0200

> I can confirm that the patch fixes the problem with my PCMCIA card :-)

Thanks for testing :)
