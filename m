Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1KUUy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:56 -0500
Date: Mon, 21 Nov 2011 12:51:39 -0800
From: Greg KH <gregkh@suse.de>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"mjg@redhat.com" <mjg@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pci: Rework ASPM disable code patch
Message-ID: <20111121205139.GA11055@suse.de> (sfid-20111121_215510_157127_49189A73)
References: <1321896029.11647.50.camel@wwguy-huron>
 <20111121182634.GA7037@suse.de>
 <1321897113.11647.52.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321897113.11647.52.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 09:38:33AM -0800, Guy, Wey-Yi wrote:
> On Mon, 2011-11-21 at 10:26 -0800, Greg KH wrote:
> > On Mon, Nov 21, 2011 at 09:20:29AM -0800, Guy, Wey-Yi wrote:
> > > Hi John/Garrett/Greg,
> > > 
> > > We test the ASPM patch with the Intel WiFi devices on number of
> > > platforms and the improvement is huge.
> > 
> > What "ASPM patch"?
> 
> https://lkml.org/lkml/2011/11/11/212

Ok, yet you feel that my statement there is not sufficient right now?

> > > In the "idle associated" mode, the power consumption number for our new
> > > devices down to ~40mW range from over 120mW.
> > > 
> > > We will do more testing but I will suggest to apply this patch to the
> > > stable release.
> > 
> > What is the git commit id of this patch?  Have you read
> > Documentation/stable_kernel_rules.txt for how to properly submit a patch
> > to the stable kernel trees?

You failed to answer this :(

{sigh}

greg k-h
