Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:38608 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYDBMrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 08:47:31 -0400
Received: by wa-out-1112.google.com with SMTP id v27so3194604wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 05:47:30 -0700 (PDT)
Message-ID: <a32f33a40804020547k1d9c945bw8e5ab97a6b1d5a55@mail.gmail.com> (sfid-20080402_134735_032947_3F08F066)
Date: Wed, 2 Apr 2008 14:47:25 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Felipe Maya" <fmay@cetuc.puc-rio.br>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Cc: TK <tobutaz@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080402135403.7fa54310@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080402001213.7b879a73@localhost>
	 <36899.201.36.161.238.1207134354.squirrel@mamao.cetuc.puc-rio.br>
	 <20080402135403.7fa54310@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  "Felipe Maya" <fmay@cetuc.puc-rio.br> a =E9crit :
>  > filename:
>  > /lib/modules/2.6.23.1/kernel/drivers/net/wireless/rt2x00/rt2500pci=
=2Eko
>  > license:        GPL
>  > description:    Ralink RT2500 PCI & PCMCIA Wireless LAN driver.
>  > version:        2.0.8

I don't know where you pulled this kernel from, but this must be a kern=
el
belonging to a particular distro, since rt2x00 was not included in
kernel 2.6.23.
The initial release in 2.6.24 had adhoc mode disabled because it was kn=
own
to be broken, apparently that patch was missing from the version your d=
istro
included.

I would recommend grabbing either wireless-testing.git or rt2x00.git
which contains
the latest version of rt2x00 where adhoc mode has been enabled again
(for testing).

Using 2.6.24 or 2.6.25 won't help since adhoc is disabled in both kerne=
ls.

Another option would be using the legacy drivers which can also handle =
adhoc and
support older kernels.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
