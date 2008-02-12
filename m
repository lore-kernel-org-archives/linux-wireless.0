Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9194 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYBLJOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 04:14:03 -0500
Received: from lin01.mn-solutions.de (pD95F9D9E.dip0.t-ipconnect.de [217.95.157.158])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id B8F4B5E4092
	for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2008 10:14:00 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 82C0B1E000E
	for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2008 10:11:04 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: madwifi is not fully open source
Date: Tue, 12 Feb 2008 10:13:47 +0100
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com> <1202770112.6824.35.camel@localhost.localdomain> <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
In-Reply-To: <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802121013.47142.hs4233@mail.mn-solutions.de> (sfid-20080212_091421_567142_191A2B65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So it seems like your three options translate to:
> 1. full Open Source: happy Open Source developers (+), can't
> sell device (big -)
> 2. firmware RF code: happy FOSS ppl (+), can sell device
> (+), depends on chip design...(not always 
> possible)
> 3. RF blob: mad FOSS ppl (- but can live with if no other
> option), can sell device(+)

If your device really doesn't have a firmware (some claim 
firmware is necessary to ensure real-time properties of the 
protocol) then you could also do:

4. write the driver for Windows in the usual, close source
   form, "leak" or give docs to some Linux developers and
   let they write the driver for the device. FCC can't object,
   you didn't wrote the driver :-)

Chances are actually quite high that the Linux people write a 
better driver than you :-)


Did you know about Greg Kroah-Hahn's "driver for free" incentive? 
http://www.kroah.com/log/linux/free_drivers.html
