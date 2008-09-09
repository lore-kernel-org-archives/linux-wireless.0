Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36794 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIIUku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 16:40:50 -0400
Date: Tue, 9 Sep 2008 15:22:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080909192241.GB3552@tuxdriver.com> (sfid-20080909_224055_285021_792F5899)
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br> <20080903190559.GO3050@tuxdriver.com> <20080903212020.GA14620@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080903212020.GA14620@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 06:20:21PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 03 Sep 2008, John W. Linville wrote:
> > > The following drivers need to check if they need to explicitly block
> > > their transmitters in their own suspend handlers (maintainers Cc'd):
> > > 	arch/arm/mach-pxa/tosa-bt.c
> > > 	drivers/net/usb/hso.c
> > > 	drivers/net/wireless/rt2x00/* (USB might need it?)
> > > 	drivers/net/wireless/b43/ (SSB over USB might need it?)
> > > 	drivers/misc/hp-wmi.c
> > > 	eeepc-laptop w/rfkill support (not in mainline yet)
> > > 	Compal laptop w/rfkill support (not in mainline yet)
> > > 	toshiba-acpi w/rfkill support (not in mainline yet)
> > 
> > Are we now satisfied that the in-kernel drivers above are all prepared
> > for this patch?
> 
> I didn't receive a single response stating that a driver would need special
> care, but then, I didn't receive many responses at all...

OK, I will plan on merging this shortly (let's say on Friday 12
September 2008) unless I hear serious objections.

John
