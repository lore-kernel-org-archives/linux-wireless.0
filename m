Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYDIUZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 16:25:27 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Wed, 9 Apr 2008 11:12:05 -0700
Cc: linux-wireless@vger.kernel.org
References: <200804011107.38563.inaky@linux.intel.com> <200804081359.03611.inaky@linux.intel.com> <200804090959.47619.hs4233@mail.mn-solutions.de>
In-Reply-To: <200804090959.47619.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804091112.05392.inaky@linux.intel.com> (sfid-20080409_212539_046487_F43EAED2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 April 2008, Holger Schurig wrote:
> > > 9. Anyway to reuse existing usbnet infrastructure?
> >
> > Nope, the 2400 is a pure IP device (as Marcel mentioned).
> 
> With "pure IP", do you mean IPv4?  Or do you mean "pure 
> IPv4/IPv6"?  If it is "pure IPv4", then WiMAX seems not future 
> proof ...

It takes both. I guess what we should be saying is that it is
not an ethernet-frame based device :) What you give the device
is sent over to the base station, so it really is whatever the
base station operator implements, which is mostly IP protocol
(4, 6 or whatever).

-- 
Inaky

