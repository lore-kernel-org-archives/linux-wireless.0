Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52916
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbXBNVkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 16:40:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Wed, 14 Feb 2007 22:40:01 +0100
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702100655.51495.mb@bu3sch.de> <1171459090.11116.22.camel@johannes.berg>
In-Reply-To: <1171459090.11116.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702142240.01494.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 February 2007 14:18, Johannes Berg wrote:
> On Sat, 2007-02-10 at 06:55 +0100, Michael Buesch wrote:
> 
> > It's likely that old cards still work with v4 firmware,
> 
> No, it's absolutely impossible. Rev 2/4 cores have a totally different
> instruction set in the microcode.

Ok, I was not talking about _that_ old cards. ;)

-- 
Greetings Michael.
