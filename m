Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1KUSaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:30:52 -0500
Date: Mon, 21 Nov 2011 10:26:34 -0800
From: Greg KH <gregkh@suse.de>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, mjg@redhat.com,
	linux-wireless@vger.kernel.org
Subject: Re: pci: Rework ASPM disable code patch
Message-ID: <20111121182634.GA7037@suse.de> (sfid-20111121_193055_507580_B4C2450D)
References: <1321896029.11647.50.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321896029.11647.50.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 09:20:29AM -0800, Guy, Wey-Yi wrote:
> Hi John/Garrett/Greg,
> 
> We test the ASPM patch with the Intel WiFi devices on number of
> platforms and the improvement is huge.

What "ASPM patch"?

> In the "idle associated" mode, the power consumption number for our new
> devices down to ~40mW range from over 120mW.
> 
> We will do more testing but I will suggest to apply this patch to the
> stable release.

What is the git commit id of this patch?  Have you read
Documentation/stable_kernel_rules.txt for how to properly submit a patch
to the stable kernel trees?

thanks,

greg k-h
