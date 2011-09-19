Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42256 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1ISOPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 10:15:34 -0400
Date: Mon, 19 Sep 2011 10:13:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Linux Wireless Stuff for IOPEN <linwir-list@iopen.net>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: Update regulatory rules for New Zealand (NZ)
Message-ID: <20110919141340.GB2608@tuxdriver.com> (sfid-20110919_161542_975958_C372D18E)
References: <4E73F3FA.502@iopen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E73F3FA.502@iopen.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 17, 2011 at 01:12:26PM +1200, Linux Wireless Stuff for IOPEN wrote:
> From Fedora 14 :
> ==============
> 
> > country NZ:
> >         (2402 - 2482 @ 40), (N/A, 30)
> >         (5170 - 5250 @ 20), (3, 23)
> >         (5250 - 5330 @ 20), (3, 23), DFS
> >         (5735 - 5835 @ 20), (3, 30)
> 
> Updates for 2.4 GHz :
> ===================
> 
>   Frequency range is 2400 to 2483.5 (Ref 1)
>   Maximum EIRP is 36 dBm (4 W)      (Ref 1)
> 
> Updates for 5 GHz :
> =================
> 
>   5150 - 5250  23 dBm (200 mW) indoor only            (Ref 1,3)
>   5250 - 5350  23 dBm (200 mW) indoor/outdoor,DFS+TPC (Ref 1,3)
>   5725 - 5875  36 dBm (  4  W) PtMP/PtP               (Ref 1,3)
>   5725 - 5825  53 dBm (200  W) PtP fixed              (Ref 1,2,3)
> 
>   And possibly this via the Spread Spectrum Device provision
> 
>   5470 - 5725  30 dBm (  1  W) requires DFS+TPC       (Ref 3)
> 
>   Maximum power density is specified for some chunks.
> 
> References :
> ==========
> 1 :
> > http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices/information-on-the-operation-of-wireless-lan-and-related-systems-in-the-2-ghz-and-5-ghz-bands
> 2 :
> > http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices
> 3 :
> > http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices
> 
> Cheers
> The IOPEN wireless deployers

Thanks for the info.  Any chance you could propose this in the form
of a patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
