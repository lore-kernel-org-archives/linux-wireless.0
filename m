Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60119 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932155AbcHKKkf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 06:40:35 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Problems with mwifiex_pcie firmware activation
Date: Thu, 11 Aug 2016 10:21:58 +0000
Message-ID: <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com> (sfid-20160811_124039_531177_32041FC2)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com> <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
In-Reply-To: <20160811090113.GA27059@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Thursday, August 11, 2016 2:31 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; linux-wireless@vger.kernel.org
> Subject: Re: Problems with mwifiex_pcie firmware activation
> 
> On Thu, Jun 23, 2016 at 02:09:52PM +0200, Stanislaw Gruszka wrote:
> > On Thu, Jun 16, 2016 at 01:53:15PM +0200, Stanislaw Gruszka wrote:
> > > On Wed, Jun 15, 2016 at 01:47:53PM +0000, Amitkumar Karwar wrote:
> > > > Could you please share complete dmesg log for failure and
> successful cases?
> > >
> > > Dmesg from failure case is in attachment. I loose access to system
> > > where device initalize, I'll provide missed dmesg when I get back
> > > the access.
> >
> > Have the access now, dmesg is in attachment.
> 
> Any news here ?

Do you have below patch included? It increases poll count which may help in your case.
https://patchwork.kernel.org/patch/7973951/

Regards,
Amitkumar
