Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50389 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750800AbYCKXCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:02:05 -0400
Message-ID: <47D70F5C.7020208@gmx.at> (sfid-20080311_230225_223084_8BBFE05A)
Date: Wed, 12 Mar 2008 00:01:48 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at> <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com> <47D70459.7000703@gmx.at> <200803112322.45274.IvDoorn@gmail.com>
In-Reply-To: <200803112322.45274.IvDoorn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn schrieb:
> rt2500pci should work with adhoc and master mode, I have to note that
> with versions up to 2.6.25 this is disabled due to lack of testing.
> I don't know which rt2x00 version is packaged in the tarball, but if it
> is older then 2.1.0 then adhoc and master mode is disabled in the driver.
> 
> Also note that although it is currently enabled, I still have not
> received test reports about it, so I cannot claim that it is working.
> 
> Ivo
> 
Found in rt2x00.h: #define DRV_VERSION    "2.1.3"

I am far away from being a wlan expert or kernel hacker.
But if that helps, I am willing to run any test you want on
Ubuntu gutsy, kernel 2.6.22.

Franz
