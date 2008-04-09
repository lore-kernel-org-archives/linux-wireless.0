Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38532 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbYDIUt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 16:49:28 -0400
From: Chr <chunkeey@web.de>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Wed, 9 Apr 2008 22:49:25 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
References: <200804011107.38563.inaky@linux.intel.com> <200804090959.47619.hs4233@mail.mn-solutions.de> <200804091112.05392.inaky@linux.intel.com>
In-Reply-To: <200804091112.05392.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804092249.26231.chunkeey@web.de> (sfid-20080409_214949_062129_4CB18308)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 April 2008 20:12:05 Inaky Perez-Gonzalez wrote:
> On Wednesday 09 April 2008, Holger Schurig wrote:
> > > > 9. Anyway to reuse existing usbnet infrastructure?
> > >
> > > Nope, the 2400 is a pure IP device (as Marcel mentioned).
> >
> > With "pure IP", do you mean IPv4?  Or do you mean "pure
> > IPv4/IPv6"?  If it is "pure IPv4", then WiMAX seems not future
> > proof ...
>
> It takes both. I guess what we should be saying is that it is
> not an ethernet-frame based device :) What you give the device
> is sent over to the base station, so it really is whatever the
> base station operator implements, which is mostly IP protocol
> (4, 6 or whatever).

It's a pity that "Internet Protocol" (as in IPv4/IPv6) as well 
as "Intellectual Property" (as in IP-Core) have the same abbreviation.

;-)

Regards,
	Chr.

