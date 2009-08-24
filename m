Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:14533 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZHXIGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 04:06:44 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Abour linux driver supports BCM4325
Date: Mon, 24 Aug 2009 10:06:05 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	feng tian <feng.of.tian@gmail.com>,
	linux-wireless@vger.kernel.org
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com> <4A90B086.1020503@lwfinger.net> <1251018830.23605.32.camel@johannes.local>
In-Reply-To: <1251018830.23605.32.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908241006.05193.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  1) changing b43 so it knows how to talk not just to
> SSB/PCI/PCMCIA chips but also SDIO chips

Feng, for this you could use another b43 card with SDIO, which 
doesn't use the LP-PHY, but the older phy. If you find such a 
device, you'll be start to code this now. As the SDIO-via-SSB 
code is identical to b43-with-LP-PHY and b43-without-LP-PHY, can 
you transfer all of this.

-- 
http://www.holgerschurig.de
