Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20151 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYFSGzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 02:55:37 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
Date: Thu, 19 Jun 2008 08:55:30 +0200
Cc: Pavel Roskin <proski@gnu.org>, Dave <kilroyd@googlemail.com>,
	Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	Bernhard Reiter <bernhard@intevation.de>
References: <200806181715.20516.bernhard@intevation.de> <4859866A.1090300@gmail.com> <1213833799.5258.13.camel@dv>
In-Reply-To: <1213833799.5258.13.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806190855.30791.hs4233@mail.mn-solutions.de> (sfid-20080619_085541_211461_18280B2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > There is a more recent version of the Agere driver
> > available, which has been patched for 2.6 kernels. See
> > <http://ubuntuforums.org/showthread.php?t=304217>
>
> It's really a low hanging fruit.  The big thing that was
> missing was firmware download for Agere, but Dave implemented
> that.

You mean I can convert the sta_h2.h file from the above link to 
some binary file and let orinoco+Dave's patches load that 
firmware to the card?

I'm asking this because I also have a bunch of Hermes I and 
Hermes II cards, which don't work with the Orinoco driver, but 
with the "brought somewhat up to kernel 2.6" wlags_h2_718.tgz 
driver from the above link. That driver works, but hurts the 
eyes, and now has some problems with 2.6.25, e.g. at unloading 
time.
