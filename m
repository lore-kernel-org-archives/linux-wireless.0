Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48700 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaAYAPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:15:36 -0500
Date: Fri, 24 Jan 2014 19:01:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: CRDA: Build Fail: Database signature verification failed
Message-ID: <20140125000113.GO4309@tuxdriver.com> (sfid-20140125_011559_728956_A56E8FDA)
References: <CABPxzYJSBagxbz4nd8=Qt_HbG4ecqe=-cbzi0N4JDPCwDE42Mg@mail.gmail.com>
 <CABPxzYLu+yjkfsi13BXG8sKoySu_CwtN+uSgwwYdiXdEq8sGMw@mail.gmail.com>
 <CAB=NE6U7zy8MeO4qLuWsEC_t69JKkS2=98crGrp4073=5WHU9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6U7zy8MeO4qLuWsEC_t69JKkS2=98crGrp4073=5WHU9Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 24, 2014 at 03:02:11PM -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 16, 2013 at 11:14 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
> > On Tue, Dec 17, 2013 at 12:20 PM, Krishna Chaitanya
> > <chaitanya.mgit@gmail.com> wrote:
> >> Hi,
> >>
> >> With the latest git source, i am seeing a build failure with the below error.
> >>
> >>   LD   crda
> >>   CC   intersect.o
> >>   LD   intersect
> >>   CC   regdbdump.o
> >>   LD   regdbdump
> >>   CC   db2rd.o
> >>   LD   db2rd
> >>   CC   optimize.o
> >>   LD   optimize
> >>   CHK  /usr/lib/crda/regulatory.bin
> >> Database signature verification failed.
> >> Invalid or empty regulatory file, note: a binary regulatory file should be used.
> >> make: *** [verify] Error 234
> >>
> >> Is there something wrong with the certificate?
> >>
> > Additional info:
> >
> > # regdbdump /usr/lib/crda/regulatory.bin
> > Database signature verification failed.
> > #  ls -l /usr/lib/crda/regulatory.bin
> > -rw-r--r-- 1 root root 3344 Dec 16 17:34 /usr/lib/crda/regulatory.bin
> >
> > regualtory.bin copied from wireless-regdb latest git.
> 
> John, what ever happened with this, I forget.

I thought these issues were resolved...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
