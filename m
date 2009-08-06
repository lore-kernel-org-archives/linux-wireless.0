Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbZHFTqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 15:46:46 -0400
Date: Thu, 6 Aug 2009 12:38:59 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	stephen.chen@atheros.com, linux-usb@vger.kernel.org,
	jbarnes@virtuousgeek.org
Subject: Re: [PATCH] Document pci_ids.h addition policy.
Message-ID: <20090806193859.GA29518@kroah.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
 <1249532170.21101.3.camel@localhost.localdomain>
 <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com>
 <1249533357.21101.5.camel@localhost.localdomain>
 <20090806050932.GA25015@kroah.com>
 <20090806181546.GA11589@redhat.com>
 <20090806183326.GA28433@kroah.com>
 <20090806191359.GA4345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090806191359.GA4345@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 06, 2009 at 03:13:59PM -0400, Dave Jones wrote:
> On Thu, Aug 06, 2009 at 11:33:26AM -0700, Greg Kroah-Hartman wrote:
>  
>  > > I agree. In fact, I'd go further, and say that the bulk of what we have
>  > > in pci_ids.h is also pointlessly shared. Only a tiny fraction of the device
>  > > entries in that file are used by multiple files in the kernel.
>  > 
>  > I agree with that as well, which is why when I was PCI maintainer, I
>  > didn't allow any new additions to the pci_ids.h file, unless it was
>  > going to be an id that was shared by different drivers.  That cut the
>  > new additions down to about none :)
> 
> Perhaps documenting this is a good idea to prevent things being moved there,
> as it still seems to be happening judging from the git log.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
