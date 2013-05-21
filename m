Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43305 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3EUPIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 11:08:04 -0400
Received: by mail-ea0-f176.google.com with SMTP id k11so486193eaj.35
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 08:08:02 -0700 (PDT)
From: "Alessandro Lannocca" <alessandro.lannocca@gmail.com>
To: "'Helmut Schaa'" <helmut.schaa@googlemail.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com> <CAGXE3d8u4ORgmOAdKFbgYSA3qTQxfhKiT6feDMMwn_-ue0ehow@mail.gmail.com>
In-Reply-To: <CAGXE3d8u4ORgmOAdKFbgYSA3qTQxfhKiT6feDMMwn_-ue0ehow@mail.gmail.com>
Subject: R: rt3070-based usb device won't accept mac address changes
Date: Tue, 21 May 2013 17:07:57 +0200
Message-ID: <000c01ce5634$fb6b3b80$f241b280$@gmail.com> (sfid-20130521_170808_917095_1CC77660)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I have an ath9k-driven integrated card active at the same time (wlan0);
but only one wlan interface (wlan1) active on the rt2800usb phy, running in
managed mode.

Thank you for your time.

-----Messaggio originale-----
Da: Helmut Schaa [mailto:helmut.schaa@googlemail.com] 
Inviato: martedì 21 maggio 2013 10.16
A: Alessandro Lannocca
Cc: linux-wireless
Oggetto: Re: rt3070-based usb device won't accept mac address changes

On Sat, May 18, 2013 at 5:10 PM, Alessandro Lannocca
<alessandro.lannocca@gmail.com> wrote:
> Hi, after switching to kernel 3.8.8 (ubuntu quantal to raring), I'm 
> unable to change my alfa AWUS036NH mac address; a simple:
>
> ifconfig <device> down
> ifconfig <device> hw ether <random hw>
>
> results in:
>
> SIOCSIFHWADDR: Invalid argument

Do you have multiple wifi interfaces or just that single one?
Helmut

