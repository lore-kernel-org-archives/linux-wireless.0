Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752237AbZJCCxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 22:53:42 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Sat, 3 Oct 2009 04:53:41 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <200910011654.10963.chunkeey@googlemail.com> <200910021345.55567.malte.gell@gmx.de> <200910022108.15155.chunkeey@googlemail.com>
In-Reply-To: <200910022108.15155.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910030453.42131.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Christian Lamparter <chunkeey@googlemail.com> wrote
 
> If you take a look at the ledtriggers values in /sys/call/leds/
> "none rfkill0 phy0rx phy0tx [phy0assoc] phy0radio",
> you instantly see that the phyXname trigger is dynamic.

Can I change the link(s) there at any time or will the ar9170usb change it 
again? 
 
> in my opinion, finding a simple udev rule is harder than simply
> modify the driver code :-D.

That's true! I just had to exchange the words "tx" with "assoc" in the driver, 
whereas a udev rule is complicated!

Regards
Malte
