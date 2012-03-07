Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40435 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2CGJlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 04:41:13 -0500
Received: by vcqp1 with SMTP id p1so5243887vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 01:41:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALx5=V98n26O88C2XkGnH8z69EKpRY6rejXxasTwZC=iZFTumA@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
	<CAD2nsn1Wu66JUaPQmK4ktjUBeCjMp4xXG2=FDy3G-LnVDwtAVA@mail.gmail.com>
	<CALx5=V98n26O88C2XkGnH8z69EKpRY6rejXxasTwZC=iZFTumA@mail.gmail.com>
Date: Wed, 7 Mar 2012 15:11:12 +0530
Message-ID: <CAD2nsn0T2ftbpaP6e1SZrDk7aMf-+C6E9Tocwn-Oj1WoNhjEcw@mail.gmail.com> (sfid-20120307_104140_769333_561FD98E)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

> yes, those are working to me now, but see the file "regval", it is
> allowed to be written. I tried to echo a value to it, and cat it, it
> seems not work right to me. :(
>
> You may try to echo "0x00000c45" > regval when the regval is
> "0x00000c55". Then cat regval again, see if it changed to
> "0x00000c45".

yes, i will quickly take a look at this. thanks for reporting.

-- 
thanks,
shafi
