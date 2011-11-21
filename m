Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1KUSek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:34:40 -0500
Subject: Re: pci: Rework ASPM disable code patch
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"mjg@redhat.com" <mjg@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111121182634.GA7037@suse.de>
References: <1321896029.11647.50.camel@wwguy-huron>
	 <20111121182634.GA7037@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 09:38:33 -0800
Message-ID: <1321897113.11647.52.camel@wwguy-huron> (sfid-20111121_193443_412641_DD81DEDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 10:26 -0800, Greg KH wrote:
> On Mon, Nov 21, 2011 at 09:20:29AM -0800, Guy, Wey-Yi wrote:
> > Hi John/Garrett/Greg,
> > 
> > We test the ASPM patch with the Intel WiFi devices on number of
> > platforms and the improvement is huge.
> 
> What "ASPM patch"?

https://lkml.org/lkml/2011/11/11/212

> 
> > In the "idle associated" mode, the power consumption number for our new
> > devices down to ~40mW range from over 120mW.
> > 
> > We will do more testing but I will suggest to apply this patch to the
> > stable release.
> 
> What is the git commit id of this patch?  Have you read
> Documentation/stable_kernel_rules.txt for how to properly submit a patch
> to the stable kernel trees?
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


