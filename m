Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35609 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbG0LOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 07:14:21 -0400
Received: by igr7 with SMTP id 7so67014889igr.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 04:14:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55B60990.10407@freenet.de>
References: <55B60990.10407@freenet.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 27 Jul 2015 21:14:01 +1000
Message-ID: <CAGRGNgVjrZHvebyc1vBZb710C5w5neWdVB+=qLB4rjBgxzK9SA@mail.gmail.com> (sfid-20150727_131428_953191_3784C97F)
Subject: =?UTF-8?Q?Re=3A_suche_intel=28R=29PRO=2FWireless_2200BG_=2D_treiber_f=C3=BCr?=
	=?UTF-8?Q?_xubuntu?=
To: Harald Seidel <seidel.h@freenet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2015-07-27 20:36 GMT+10:00 Harald Seidel <seidel.h@freenet.de>:
> Bitte um Hilfe,
>
> suche einen intel(R)PRO/Wireless 2200BG - treiber für xubuntu...
> war auf der "http://ipw2200.sourceforge.net/" - Seite, konnte aber keine
> verbindung
> zum Server bekommen...kann man mir helfen.

The driver should be included in your distribution's kernel. It's
called "ipw2200" and should have been loaded automatically.

You will also need the firmware. Your distribution should have
packaged it. In Debian it's in the "firmware-ipw2x00" package.

Hope that helps!

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
