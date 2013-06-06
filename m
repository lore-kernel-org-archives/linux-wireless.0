Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46590 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3FFLJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:09:18 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so1515465bkc.29
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 04:09:17 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "C.B. Wang" <wtwangcb@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
Date: Thu, 6 Jun 2013 13:09:12 +0200
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com> <CAJ-Vmom6cmf-c-TJs5s9AvT953m0+tANVj_AxnSYwUCzegyPWQ@mail.gmail.com> <CAB-Tk7273qtgA0J-rvpFxNbMDErmXVdknybVOJmUTa73VhL1Cw@mail.gmail.com>
In-Reply-To: <CAB-Tk7273qtgA0J-rvpFxNbMDErmXVdknybVOJmUTa73VhL1Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201306061309.12781.chunkeey@googlemail.com> (sfid-20130606_130921_575642_2A2C35EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 06, 2013 10:07:46 AM C.B. Wang wrote:
> Spectral analysis isn't supported by any Atheros USB
> chipsets, is it?
maybe by the ar7010+ar92xy combo. Anyway, if you need it
for your job, then you should help implementing it!

> The 802.11j standard defines 10mhz operation. I think
> it is mandatory. You can get a copy here
> http://www.it.iitb.ac.in/~mukesh/dokuwiki/lib/exe/fetch.php?cache=cache&media=mtp:802.11j-2004.pdf
Can you tell me on what page/chapter? Thanks!

> Channel 183(4815mhz),185(4925mhz),187(4935mhz),189(4945mhz)
> should also be added to the channel list of carl9170 driver.
Hey that's great. Please send us patch then. Testing is not
possible here in Germany, the regdomain doesn't allow it.

Regards,
	Chr
