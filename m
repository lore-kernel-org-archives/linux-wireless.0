Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:64840 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYCYVQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 17:16:00 -0400
Received: by ug-out-1314.google.com with SMTP id z38so2521595ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 14:15:58 -0700 (PDT)
To: Balaji Rao <balajirrao@gmail.com>
Subject: Re: Question on Wireless NICs
Date: Tue, 25 Mar 2008 22:15:08 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200803260011.29045.balajirrao@gmail.com> <20080325193219.GC30587@tuxdriver.com>
In-Reply-To: <20080325193219.GC30587@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803252215.09057.IvDoorn@gmail.com> (sfid-20080325_211607_333142_A66CD66A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 March 2008, John W. Linville wrote:
> On Wed, Mar 26, 2008 at 12:11:28AM +0530, Balaji Rao wrote:
> 
> > My question is, are there any wireless NICs that don't require a firmware to be loaded into them to work ?
> 
> There are some, although many of them are old:  adm8211, airo, ath5k,
> rtl8180, rtl8187, and some of the rt2x00 devices.

For rt2x00 the following:
rt2400pci, rt2500pci and rt2500usb

> > I was planning to boot off a wireless NIC through PXE. Is it possible ??
> 
> The gPXE (formerly etherboot) project seems to support PCI-based
> (e.g. cardbus, but not PCMCIA) orinoco devices.  I cannot verify that,
> since I have no such device (donations accepted!)...
> 
> Hth!
> 
> John


