Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44121 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbYDXRVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 13:21:37 -0400
Subject: Re: Update: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335
	[Libertas]"
From: David Woodhouse <David@Woodhou.se>
To: Dan Williams <dcbw@redhat.com>
Cc: Markus Becker <mab@comnets.uni-bremen.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	julian.calaby@gmail.com, andreamrl@tiscali.it
In-Reply-To: <1209057222.5224.3.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
	 <200803191124.03743.hs4233@mail.mn-solutions.de>
	 <Pine.LNX.4.64.0803281122240.21835@bugs.comnets.uni-bremen.de>
	 <1206992394.12973.39.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0804030921150.21835@bugs.comnets.uni-bremen.de>
	 <1207943754.3364.1.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0804140910580.21835@bugs.comnets.uni-bremen.de>
	 <1209057222.5224.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 18:21:20 +0100
Message-Id: <1209057680.9212.1065.camel@pmac.infradead.org> (sfid-20080424_192208_709976_B091E3FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-24 at 13:13 -0400, Dan Williams wrote:
> 
> As a note, the driver works a lot better with a 3Com CardBus card than
> with the Netgear PCI card.  Not sure if firmwares make a difference; I
> used the firmware from each card's respective driver CD.  I'm trying to
> clean up some of the bits of the driver.  We should really get a git
> tree for this though.

You can create trees in ~/public_git on bombadil.infradead.org if you
want to, and we can set up shared trees in /srv/git too.

-- 
dwmw2

