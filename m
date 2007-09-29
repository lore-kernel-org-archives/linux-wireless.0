Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47028
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXI2Rfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 13:35:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
Date: Sat, 29 Sep 2007 19:32:57 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200709281422.34434.mb@bu3sch.de> <200709291908.24758.mb@bu3sch.de> <1191086074.8203.18.camel@shinybook.infradead.org>
In-Reply-To: <1191086074.8203.18.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709291932.57924.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 September 2007 19:14:34 David Woodhouse wrote:
> On Sat, 2007-09-29 at 19:08 +0200, Michael Buesch wrote:
> > I'm not sure what you are trying to ask.
> 
> The hunks I quoted don't seem relevant to the rfkill switch. They seem
> to be related to periodic work, which was the subject of the other patch
> you posted at about the same time. Did you get them mixed up?

The patch is correct as-is. RF-kill was polled by the periodic work.

-- 
Greetings Michael.
