Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbXBVPpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 10:45:36 -0500
Subject: Re: [git patches] net driver updates
From: Dan Williams <dcbw@redhat.com>
To: jeff@garzik.org
Cc: Roger While <simrw@sim-basis.de>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070221132754.GA4978@tuxdriver.com>
References: <6.1.1.1.2.20070221124144.04783fb8@192.168.6.12>
	 <20070221132754.GA4978@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:48:30 -0500
Message-Id: <1172159310.5114.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-02-21 at 08:27 -0500, John W. Linville wrote:
> On Wed, Feb 21, 2007 at 12:46:46PM +0100, Roger While wrote:
> > 
> > >
> > >Dan Williams (1):
> > >      prism54: correct assignment of DOT1XENABLE in WE-19 codepaths
> > 
> > Where did this spring from ?
> > I see no posting of this patch let alone
> > an ACK.
> > The patch is also doing rather more than the description -
> > It is inserting extra breaks into a switch statement with
> > no comment as to why.
> 
> Dan posted it to linux-wireless@vger.kernel.org on 13 Feb 2007.
> The description in the body is quoted below:

It was also posted to stable@kernel.org and accepted for 2.6.19 and
2.6.20.

Dan

> 	Correct assignment of DOT1XENABLE in WE-19 codepaths.
> 	RX_UNENCRYPTED_EAPOL = 1 really means setting DOT1XENABLE _off_, and
> 	vice versa.  The original WE-19 patch erroneously reversed that.  This
> 	patch fixes association with unencrypted and WEP networks when using
> 	wpa_supplicant.
> 	
> 	It also adds two missing break statements that, left out, could result
> 	in incorrect card configuration.
> 	
> 	Please commit to both development and stable branches.
> 
> Hth...
> 
> John

