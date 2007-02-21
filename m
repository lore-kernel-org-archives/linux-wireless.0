Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2838 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161236AbXBUNvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 08:51:42 -0500
Date: Wed, 21 Feb 2007 08:27:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Roger While <simrw@sim-basis.de>
Cc: netdev@vger.kernel.org, jeff@garzik.org, dcbw@redhat.com,
	linux-wireless@vger.kernel.org
Subject: Re: [git patches] net driver updates
Message-ID: <20070221132754.GA4978@tuxdriver.com>
References: <6.1.1.1.2.20070221124144.04783fb8@192.168.6.12>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6.1.1.1.2.20070221124144.04783fb8@192.168.6.12>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 21, 2007 at 12:46:46PM +0100, Roger While wrote:
> 
> >
> >Dan Williams (1):
> >      prism54: correct assignment of DOT1XENABLE in WE-19 codepaths
> 
> Where did this spring from ?
> I see no posting of this patch let alone
> an ACK.
> The patch is also doing rather more than the description -
> It is inserting extra breaks into a switch statement with
> no comment as to why.

Dan posted it to linux-wireless@vger.kernel.org on 13 Feb 2007.
The description in the body is quoted below:

	Correct assignment of DOT1XENABLE in WE-19 codepaths.
	RX_UNENCRYPTED_EAPOL = 1 really means setting DOT1XENABLE _off_, and
	vice versa.  The original WE-19 patch erroneously reversed that.  This
	patch fixes association with unencrypted and WEP networks when using
	wpa_supplicant.
	
	It also adds two missing break statements that, left out, could result
	in incorrect card configuration.
	
	Please commit to both development and stable branches.

Hth...

John
-- 
John W. Linville
linville@tuxdriver.com
