Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4241 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYAYDDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 22:03:34 -0500
Date: Thu, 24 Jan 2008 21:47:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH v2] PS3: gelic: Add wireless support for PS3
Message-ID: <20080125024725.GB3411@tuxdriver.com> (sfid-20080125_030341_969745_FEEABE20)
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp> <20080124144253.6176.40F06B3A@sm.sony.co.jp> <1201225785.15917.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201225785.15917.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2008 at 08:49:45PM -0500, Dan Williams wrote:
> On Thu, 2008-01-24 at 14:51 +0900, Masakazu Mokuno wrote:
> > Hi
> > 
> > PS3: gelic: Add wireless support for PS3
> > 
> > This is the version 2 of the re-worked (rewritten) version of the
> > wireless support driver for PS3.  The version 1 of the new driver was
> > submitted on 13th Dec. 2007 (and the old one was submitted to net-dev ML
> > in June 2007).
> > 
> > Major differences with the old driver are:
> >   - The new driver has a separate ethX interface from ethernet.
> >     They share the same MAC address.
> >   - Thus we can use both ethernet and wireless simultaenously.
> >   - The new driver returns AP's cipher information by the common IE
> >     format in the scan information.
> >   - Cipher selection is done via the common wireless extension way
> 
> Looks like all my issues have been addressed.  Thanks!  Lets get this in
> 2.6.25 :)
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

ACK -- please merge it with the other patches through the powerpc tree.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
