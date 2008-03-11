Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34820 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752001AbYCKWPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 18:15:03 -0400
Message-ID: <47D70459.7000703@gmx.at> (sfid-20080311_221510_826407_92905A74)
Date: Tue, 11 Mar 2008 23:14:49 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at>	 <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com>	 <47D5AAFC.80401@gmx.at> <200803102321.35909.IvDoorn@gmail.com>	 <20080310233307.GT28995@ruslug.rutgers.edu> <47D5CD59.5050400@gmx.at> <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com>
In-Reply-To: <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:
>>  Loaded the new tarball.
>>  It compiles fine.
> 
> And it works too I hope? :)
> 
>   Luis
> 
Unfortunately not. I am still trying to find out, if it is my fault or not.

It seems, that it only allows Managed mode.
"iwconfig wlan0 mode Ad-Hoc" and "iwconfig wlan0 mode Master" both give 
me this error:
Error for wireless request "Set Mode" (8B06) :
     SET failed on device wlan0 ; Invalid argument.

I intended to use an ad-hoc connection between 2 PCs.
Since I have no access point I cannot test much at the moment.

Is it supposed to provide ad-hoc and master mode on rt2500 (pci)?
Probably not yet, because it is not in the list 
(http://linuxwireless.org/en/users/Drivers). Right?

Franz
