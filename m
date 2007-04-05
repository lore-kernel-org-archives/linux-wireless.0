Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53997
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767132AbXDERb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 13:31:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcus Glocker <marcus@nazgul.ch>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Thu, 5 Apr 2007 19:31:10 +0200
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
References: <200704041945.21447.mb@bu3sch.de> <20070405054107.GB7660@gollum.nazgul.ch> <20070405163434.GA18477@gollum.nazgul.ch>
In-Reply-To: <20070405163434.GA18477@gollum.nazgul.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704051931.11044.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 April 2007 18:34, Marcus Glocker wrote:
> OK, I decided to go for option 3:
> 
> ***
> 
> From: Marcus Glocker <mglocker@cvs.openbsd.org>                                 
> To: source-changes@cvs.openbsd.org                                              
> Date: Thu, 5 Apr 2007 10:25:25 -0600 (MDT)                                      
> Subject: CVS: cvs.openbsd.org: src                                              
>   
> CVSROOT:        /cvs
> Module name:    src
> Changes by:     mglocker@cvs.openbsd.org        2007/04/05 10:25:25
>   
> Modified files:
>         sys/conf       : files
>         sys/dev/pci    : files.pci
>         sys/dev/cardbus: files.cardbus
> Removed files:
>         share/man/man4 : bcw.4
>         sys/dev/ic     : bcw.c bcwreg.h bcwvar.h
>         sys/dev/pci    : if_bcw_pci.c
>         sys/dev/cardbus: if_bcw_cardbus.c
>   
> Log message:
> After been attacked by Michael Buesch <mb@bu3sch.de> because we initially
> were using some of their routines in the bcw driver, I decided to stop
> working on it.  To avoid any further license chit chat I plain drop the
> driver.
> 
> ***
> 
> Happy now?
> 
> It's a pleasure to see how the OpenSource community stands together,
> and starting public wars instead of talking directly to the people
> involved.

I don't understand your reaction, really.
If you were really interrested in doing a Broadcom wireless driver for
openbsd, you would have chosen the option to relicense some code (and
therefore drop only that code which I refuse to relicense), which I gave
you.

It's a pity. I'd like you to sleep a night over this and rethink
your decision tomorrow.
Feel free to contact us to get code relicensed _before_ you re-add
it to the repository. This will make you and us happy and I'm sure
you'll have a working driver soon.

-- 
Greetings Michael.
