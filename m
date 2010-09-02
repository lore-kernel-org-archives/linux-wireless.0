Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab0IBD03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 23:26:29 -0400
Date: Wed, 1 Sep 2010 20:25:27 -0700
From: Greg KH <greg@kroah.com>
To: G?bor Stefanik <netrolller.3d@gmail.com>
Cc: Vipin Mehta <vmehta@atheros.com>, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
Message-ID: <20100902032527.GA27598@kroah.com>
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com> <20100902013545.GB4744@kroah.com> <AANLkTim-OPNM20swWXtHF0VufVjMHpcs-OUVTLCmTPRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim-OPNM20swWXtHF0VufVjMHpcs-OUVTLCmTPRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 02, 2010 at 04:29:31AM +0200, G?bor Stefanik wrote:
> On Thu, Sep 2, 2010 at 3:35 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Sep 01, 2010 at 03:51:13PM -0700, Vipin Mehta wrote:
> >> The patch adds support for the 802.11 chip, AR6003. It has been
> >> generated against the linux-next tree and is being targeted
> >> for the staging area.
> >
> > -ENOPATCH :(
> 
> On Wed, Sep 01, 2010 at 03:51:13PM -0700, Vipin Mehta wrote:
> > The actual patch can be downloaded from the following location:
> > http://www.kernel.org/~vmehta/0001-staging-add-ath6kl-driver-for-AR6003-chip.patch.gz
> 
> This one.

I'm guessing someone forgot to read section 7 in
Documentation/SubmittingPatches.  I can't do much with a link, git
doesn't like it, nor does quilt.  Please send it through email so that I
can apply it.

And yes, I know about section 8, but my email can handle large sized
patches...

Vipin, did you really want me to take that compressed patch above and
use it?  Or can you send it by email to me?

thanks,

greg k-h
