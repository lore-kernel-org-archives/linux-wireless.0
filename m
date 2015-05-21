Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbEUElF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 00:41:05 -0400
Date: Wed, 20 May 2015 21:41:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521044104.GH22632@kroah.com> (sfid-20150521_064122_206988_3BC109EA)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150520164613.GD10473@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 07:46:13PM +0300, Petko Manolov wrote:
> On 15-05-20 17:24:46, One Thousand Gnomes wrote:
> > 
> > More to the point why do you want to sign firmware files ? Leaving aside the 
> > fact that someone will produce a device with GPLv3 firmware just to p*ss you 
> > off there's the rather more relevant fact that firmware for devices on a so 
> > called "trusted" platform already have signed firmware.
> 
> For "trusted" systems one would like to make sure everything that goes in has 
> known provenance.  Maybe this was the idea?

If so, then just do what people do today, verify their known valid disk
image before mounting it and then they know they can trust the data on
it to be use for whatever (including firmware.)  No kernel changes
needed, distro support is already there for this.

I too don't understand this need to sign something that you don't really
know what it is from some other company, just to send it to a separate
device that is going to do whatever it wants with it if it is signed or
not.

thanks,

greg k-h
