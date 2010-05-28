Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:40090 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0E1KkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 06:40:17 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id o4SAeFl4009716
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 12:40:15 +0200
Received: from mail2.itwm.fhg.de ([131.246.191.79]:42805)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1)
	 (Exim 4.66 #1)
	id 1OHwz9-0006VQ-AP
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 12:40:15 +0200
Message-ID: <4BFF9D8E.5040702@itwm.fraunhofer.de>
Date: Fri, 28 May 2010 12:40:14 +0200
From: Martin Vogt <martin.vogt@itwm.fraunhofer.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: new bluetooth id for lenovo T410s?
References: <4BFE4124.2090601@itwm.fraunhofer.de> <1274957276.4706.4.camel@aeonflux.t-mobile.de>
In-Reply-To: <1274957276.4706.4.camel@aeonflux.t-mobile.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann wrote:
> Hi Martin,
> 
> so first of all, this is the wrong mailing list. You should be using
> linux-bluetooth@vger.kernel.org.
Oh, ok.

> Please send in the output of /proc/bus/usb/devices for your devices
> since I doubt it is not supported. There are general interface
> descriptors that make the devices work. Only if Lenovo screwed something
> up, then this is needed.
> 

Just a small update: It works now, the btusb driver
from the compat-wireless module didnt load with symbol
problems.
(I use a Suse 2.6.27 vendor kernel which already is a bit 2.6.28+
compat-wireless-2.6.34)

I placed some #if 0 #endif combinations in compat-2.6.28.c
==>now it works.

regards,

Martin

