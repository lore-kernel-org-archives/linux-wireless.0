Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47249 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYICVUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 17:20:30 -0400
Date: Wed, 3 Sep 2008 18:20:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080903212020.GA14620@khazad-dum.debian.net> (sfid-20080903_232033_373901_AD803DAD)
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br> <20080903190559.GO3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080903190559.GO3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 03 Sep 2008, John W. Linville wrote:
> > The following drivers need to check if they need to explicitly block
> > their transmitters in their own suspend handlers (maintainers Cc'd):
> > 	arch/arm/mach-pxa/tosa-bt.c
> > 	drivers/net/usb/hso.c
> > 	drivers/net/wireless/rt2x00/* (USB might need it?)
> > 	drivers/net/wireless/b43/ (SSB over USB might need it?)
> > 	drivers/misc/hp-wmi.c
> > 	eeepc-laptop w/rfkill support (not in mainline yet)
> > 	Compal laptop w/rfkill support (not in mainline yet)
> > 	toshiba-acpi w/rfkill support (not in mainline yet)
> 
> Are we now satisfied that the in-kernel drivers above are all prepared
> for this patch?

I didn't receive a single response stating that a driver would need special
care, but then, I didn't receive many responses at all...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
