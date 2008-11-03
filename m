Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40856 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbYKCRCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 12:02:50 -0500
Date: Mon, 3 Nov 2008 15:02:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Message-ID: <20081103170243.GB2417@khazad-dum.debian.net> (sfid-20081103_180255_559882_98723848)
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811031747.16326.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 03 Nov 2008, Ivo van Doorn wrote:
> On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> > This small patchset contains two fixes to issues in the suspend/resume
> > handling of the rfkill class core.
> > 
> > It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.
> 
> Are they real regressions or normal bugfixes?

I am not sure if they regress anything, but I am pretty sure there is no
bugzilla entry about them yet.  I have added two more interested parties to
the CC.

So, if there is a strong feeling this would best be held until the next
merge window, I can certainly respin the patches to on top of
wireless-testing...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
