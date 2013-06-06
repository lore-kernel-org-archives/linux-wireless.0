Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52812 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab3FFIRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 04:17:13 -0400
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lex3B-1U2QXX1un9-00qidu for
 <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 10:17:12 +0200
Message-ID: <51B04585.9020108@gmx.net> (sfid-20130606_101719_928154_D1774DFF)
Date: Thu, 06 Jun 2013 10:17:09 +0200
From: Oleksij Rempel <fishor@gmx.net>
MIME-Version: 1.0
To: "C.B. Wang" <wtwangcb@gmail.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com> <CAB-Tk73mTDsvf+MCEq5xfUBUtE4c6KfL2nkAcZe2LCY5pF=7RQ@mail.gmail.com> <CAJ-Vmok5yLZvstvYHi35ALWG3q8sVYLx_1PuhL31unOjxrg-4g@mail.gmail.com> <201306052335.25953.chunkeey@googlemail.com> <CAJ-Vmom6cmf-c-TJs5s9AvT953m0+tANVj_AxnSYwUCzegyPWQ@mail.gmail.com> <CAB-Tk7273qtgA0J-rvpFxNbMDErmXVdknybVOJmUTa73VhL1Cw@mail.gmail.com>
In-Reply-To: <CAB-Tk7273qtgA0J-rvpFxNbMDErmXVdknybVOJmUTa73VhL1Cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.06.2013 10:07, schrieb C.B. Wang:
> Spectral analysis isn't supported by any Atheros USB chipsets,is it?

ar7010 devices theoretically should support it.

> The 802.11j standard defines 10mhz operation.I think it is mandatory.
> You can get a copy here
> http://www.it.iitb.ac.in/~mukesh/dokuwiki/lib/exe/fetch.php?cache=cache&media=mtp:802.11j-2004.pdf
>
> No,I don't know any.Most devices that use ZyDaS chipset are b/g soloution.
> It's rare even to see an a/b/g ZyDaS device.
>
> Channel 183(4815mhz),185(4925mhz),187(4935mhz),189(4945mhz) should also
> be added to the channel list of carl9170 driver.
>


