Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:43139 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZAYShn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 13:37:43 -0500
Received: by ewy3 with SMTP id 3so553622ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 10:37:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>
Date: Sun, 25 Jan 2009 19:37:40 +0100
Message-ID: <14b026160901251037m43efe6efjde4a185a517ddf66@mail.gmail.com> (sfid-20090125_193749_198590_A893AB4E)
Subject: Re: [b43] opensource firmware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5polish@gmail.com>
To: Lorenzo Nava <navalorenx@gmail.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/14 Lorenzo Nava <navalorenx@gmail.com>:
> we completed the 1st version of initvals. They are available at http:=
//www.ing.unibs.it/openfwwf
> . Currently only binary version is available: don't worry, we will
> publish source code as soon as possible!! This first version is a
> "test version": please try it and let us know if everythink is ok...
>
> Today we have also tested a new firmware version that works with WPA2=
-
> personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS) (tested
> on 4306 and 4318 PCI device). If anybody was interested please try ne=
w
> firmware with encryption and let us know if it works correctly, thank=
s!
>
> Initvals and new firmware version can be found at http://www.ing.unib=
s.it/openfwwf

I belive you still need testing?

I used openfwwf-5.0.tar.gz and initvals.tar.gz for my bcm4318 card  in
Acer Aspire 5024 (qos=3D0). Scanning works fine, connecting to WPA
Personal network also. I can't check speed performance as I don't have
antenna connected to my card (notebook lid just gone... I belive
"Acer" explains that situation to you?). As for stability it's great.
I downloaded 100MB, left notebook for 24h and then downloaded another
50MB.

So to sum up: I don't feel any difference between opensource and
broardcom's firmware.

--=20
Rafa=C5=82 Mi=C5=82ecki
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
