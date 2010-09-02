Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38213 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab0IBRyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 13:54:13 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 10:54:08 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <greg@kroah.com>, G?bor Stefanik <netrolller.3d@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Thu, 2 Sep 2010 10:54:03 -0700
Subject: RE: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
Message-ID: <35B17FE5076C7040809188FBE7913F983F234795C2@SC1EXMB-MBCL.global.atheros.com>
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
 <20100902013545.GB4744@kroah.com>
 <AANLkTim-OPNM20swWXtHF0VufVjMHpcs-OUVTLCmTPRw@mail.gmail.com>
 <20100902032527.GA27598@kroah.com>
In-Reply-To: <20100902032527.GA27598@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Greg,
    Besides the size of the original patch, I was not very confident of the exchange server through which my emails go out. The patch may get mangled in which case you wont be able to apply it. I am working on it to make sure that I have a reliable way to send the patches out. Until then, downloading the patch from the location that I specified may be a better option. 

http://www.kernel.org/~vmehta/0001-staging-add-ath6kl-driver-for-AR6003-chip.patch.gz

If the link above does not work out, then I'll send the patch to you via an email (its about 5 MB uncompressed). Let me know.

Regards,
Vipin

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Wednesday, September 01, 2010 8:25 PM
> To: G?bor Stefanik
> Cc: Vipin Mehta; linux-wireless@vger.kernel.org; Luis 
> Rodriguez; devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
> 
> On Thu, Sep 02, 2010 at 04:29:31AM +0200, G?bor Stefanik wrote:
> > On Thu, Sep 2, 2010 at 3:35 AM, Greg KH <greg@kroah.com> wrote:
> > > On Wed, Sep 01, 2010 at 03:51:13PM -0700, Vipin Mehta wrote:
> > >> The patch adds support for the 802.11 chip, AR6003. It has been 
> > >> generated against the linux-next tree and is being 
> targeted for the 
> > >> staging area.
> > >
> > > -ENOPATCH :(
> > 
> > On Wed, Sep 01, 2010 at 03:51:13PM -0700, Vipin Mehta wrote:
> > > The actual patch can be downloaded from the following location:
> > > 
> http://www.kernel.org/~vmehta/0001-staging-add-ath6kl-driver-for-AR6
> > > 003-chip.patch.gz
> > 
> > This one.
> 
> I'm guessing someone forgot to read section 7 in 
> Documentation/SubmittingPatches.  I can't do much with a 
> link, git doesn't like it, nor does quilt.  Please send it 
> through email so that I can apply it.
> 
> And yes, I know about section 8, but my email can handle 
> large sized patches...
> 
> Vipin, did you really want me to take that compressed patch 
> above and use it?  Or can you send it by email to me?
> 
> thanks,
> 
> greg k-h
> 