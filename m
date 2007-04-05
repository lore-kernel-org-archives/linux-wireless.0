Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46466
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXDEQrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 12:47:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcus Glocker <marcus@nazgul.ch>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Thu, 5 Apr 2007 18:47:05 +0200
Cc: Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
References: <200704041945.21447.mb@bu3sch.de> <20070405054107.GB7660@gollum.nazgul.ch>
In-Reply-To: <20070405054107.GB7660@gollum.nazgul.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704051847.05778.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 April 2007 07:41, Marcus Glocker wrote:
> I wanted to make some quick progress (maybe too quick), and rewrite
> the functions in question after seeing some first success, e.g.
> receivment of first frames, which isn't the case right now.  But
> still, the specs for some functions are so strict, writing tons
> of registers in a strict order, some parts will still look similar.

To make it clear. We are not issueing any copyright claims on
these magic register sequences.
This is only about algorithms and so on. I mentioned the LO state
machine, for example.

> The last thing I want is to start a license war with you guys,
> and also I don't want to harm OpenBSD further with this issue.
> And of course we want to solve that license issue ASAP.
> 
> So, I am suggestion three options:
> 
> 	1. You give me some time and I try to rewrite the code
> 	   in question.  We keep in touch, and maybe we can split
> 	   up both parties in freedom afterwards.
> 
> 	2. Same as option one, but if my time resources keep
> 	   shrinking like they do right now, spending weekends
> 	   in the office and I can't fix up the driver soon,
> 	   I'll drop the driver.
> 
> 	3. We don't come to a point and I'll plain drop the driver
> 	   directly, very soon.

	4. bcm43xx people review the driver and think about relicensing
	   (parts of) bcw, so you don't have to rewrite it.
	   We don't want to distrurb bcw development, but we don't like
	   the harsh way of taking code without permission and asking
	   for permission afterwards.
	   If you want to have more code relicensed, please ask on a
	   case-by-case base _before_ importing it into bcw.

-- 
Greetings Michael.
