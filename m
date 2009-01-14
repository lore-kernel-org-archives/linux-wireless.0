Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:48301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZANP5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 10:57:12 -0500
Received: by rv-out-0506.google.com with SMTP id k40so584462rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 07:57:09 -0800 (PST)
Message-ID: <30c8a83c0901140757w5ee3c859wd0685d0b5f3a2e29@mail.gmail.com> (sfid-20090114_165717_092883_D9090B62)
Date: Wed, 14 Jan 2009 09:57:09 -0600
From: "Buran Ayuthia" <the.ayuthias@googlemail.com>
To: "Lorenzo Nava" <navalorenx@gmail.com>
Subject: Re: [b43] opensource firmware
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My 4311 rev 01 card still works with the new initvals and firmware
using WPA2-personal (both TKIP and CCMP) and without encyrption.  I am
still loading the module using modprobe b43 qos=0.

Buran Ayuthia

On Wed, Jan 14, 2009 at 9:30 AM, Lorenzo Nava <navalorenx@gmail.com> wrote:
> Hello everybody,
>
> we completed the 1st version of initvals. They are available at http://www.ing.unibs.it/openfwwf
> . Currently only binary version is available: don't worry, we will
> publish source code as soon as possible!! This first version is a
> "test version": please try it and let us know if everythink is ok...
>
> Today we have also tested a new firmware version that works with WPA2-
> personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS) (tested
> on 4306 and 4318 PCI device). If anybody was interested please try new
> firmware with encryption and let us know if it works correctly, thanks!
>
> Initvals and new firmware version can be found at http://www.ing.unibs.it/openfwwf
>
> Cheers
>
> Lorenzo Nava
> Francesco Gringoli
>
>
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>
