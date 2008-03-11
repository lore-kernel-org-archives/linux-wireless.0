Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:20918 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYCKWXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 18:23:09 -0400
Received: by py-out-1112.google.com with SMTP id u52so3883737pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 15:23:09 -0700 (PDT)
To: Franz Apeltauer <franz.apeltauer@gmx.at>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Date: Tue, 11 Mar 2008 23:22:45 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <47CB3B5E.4020701@gmx.at> <43e72e890803101826m5b7cd55ao9f521a786a36c07@mail.gmail.com> <47D70459.7000703@gmx.at>
In-Reply-To: <47D70459.7000703@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803112322.45274.IvDoorn@gmail.com> (sfid-20080311_222313_996568_F66ADFA6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 March 2008, Franz Apeltauer wrote:
> Luis R. Rodriguez schrieb:
> >>  Loaded the new tarball.
> >>  It compiles fine.
> > 
> > And it works too I hope? :)
> > 
> >   Luis
> > 
> Unfortunately not. I am still trying to find out, if it is my fault or not.
> 
> It seems, that it only allows Managed mode.
> "iwconfig wlan0 mode Ad-Hoc" and "iwconfig wlan0 mode Master" both give 
> me this error:
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wlan0 ; Invalid argument.
> 
> I intended to use an ad-hoc connection between 2 PCs.
> Since I have no access point I cannot test much at the moment.
> 
> Is it supposed to provide ad-hoc and master mode on rt2500 (pci)?
> Probably not yet, because it is not in the list 
> (http://linuxwireless.org/en/users/Drivers). Right?

rt2500pci should work with adhoc and master mode, I have to note that
with versions up to 2.6.25 this is disabled due to lack of testing.
I don't know which rt2x00 version is packaged in the tarball, but if it
is older then 2.1.0 then adhoc and master mode is disabled in the driver.

Also note that although it is currently enabled, I still have not
received test reports about it, so I cannot claim that it is working.

Ivo
