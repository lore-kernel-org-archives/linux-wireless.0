Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3832 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYCYUGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 16:06:43 -0400
Date: Tue, 25 Mar 2008 15:32:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Question on Wireless NICs
Message-ID: <20080325193219.GC30587@tuxdriver.com> (sfid-20080325_200649_133573_97EDF554)
References: <200803260011.29045.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803260011.29045.balajirrao@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 12:11:28AM +0530, Balaji Rao wrote:

> My question is, are there any wireless NICs that don't require a firmware to be loaded into them to work ?

There are some, although many of them are old:  adm8211, airo, ath5k,
rtl8180, rtl8187, and some of the rt2x00 devices.

> I was planning to boot off a wireless NIC through PXE. Is it possible ??

The gPXE (formerly etherboot) project seems to support PCI-based
(e.g. cardbus, but not PCMCIA) orinoco devices.  I cannot verify that,
since I have no such device (donations accepted!)...

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
