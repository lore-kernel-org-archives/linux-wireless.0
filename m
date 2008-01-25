Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:65343 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYAYDiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 22:38:50 -0500
Date: Fri, 25 Jan 2008 12:36:38 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] PS3: gelic: Add wireless support for PS3
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080125024725.GB3411@tuxdriver.com>
References: <1201225785.15917.8.camel@localhost.localdomain> <20080125024725.GB3411@tuxdriver.com>
Message-Id: <20080125122408.5CC6.40F06B3A@sm.sony.co.jp> (sfid-20080125_033856_492608_C2BA48E6)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 24 Jan 2008 21:47:25 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Thu, Jan 24, 2008 at 08:49:45PM -0500, Dan Williams wrote:
> > On Thu, 2008-01-24 at 14:51 +0900, Masakazu Mokuno wrote:
> > > Hi
> > > 
> > > PS3: gelic: Add wireless support for PS3
> > > 
> > > This is the version 2 of the re-worked (rewritten) version of the
> > > wireless support driver for PS3.  The version 1 of the new driver was
> > > submitted on 13th Dec. 2007 (and the old one was submitted to net-dev ML
> > > in June 2007).
> > > 
> > > Major differences with the old driver are:
> > >   - The new driver has a separate ethX interface from ethernet.
> > >     They share the same MAC address.
> > >   - Thus we can use both ethernet and wireless simultaenously.
> > >   - The new driver returns AP's cipher information by the common IE
> > >     format in the scan information.
> > >   - Cipher selection is done via the common wireless extension way
> > 
> > Looks like all my issues have been addressed.  Thanks!  Lets get this in
> > 2.6.25 :)
> > 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> ACK -- please merge it with the other patches through the powerpc tree.
> 
> Thanks,
> 
> John

Thank you, John, Dan.

I'll ask Paul to merge this if the wired part of dependent gelic patches
gets acked from network people.


-- 
Masakazu MOKUNO

