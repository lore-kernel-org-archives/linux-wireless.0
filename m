Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:55503 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S637774AbXDSN7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 09:59:09 -0400
Date: Thu, 19 Apr 2007 15:58:05 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] bcm43xx-mac80211: Fix machine check on PPC for  phy->rev == 1
Message-ID: <20070419155805.611244ec@localhost>
In-Reply-To: <462772da.WTFJ4M8EynD9kYbu%Larry.Finger@lwfinger.net>
References: <462772da.WTFJ4M8EynD9kYbu%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Apr 2007 08:47:06 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> @@ -599,16 +599,16 @@ static void bcm43xx_phy_agcsetup(struct 

Just FYI, I'm going to whack this whole function soon, when the R.E. team
is done with A PHY LO specifications and I release the patchset I previously
talked about. In the meanwhile, if this really fixes machine checks, I ACK
this.


--
Ciao
Stefano
