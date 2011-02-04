Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1BDIMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 03:12:44 -0500
Received: by bwz15 with SMTP id 15so2473941bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 00:12:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [RFT/RFC] carl9170: export HW random number generator
Date: Fri, 4 Feb 2011 09:12:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <cb1597685120e228d2c66a7eafc07aed1466f7dd.1296769444.git.chunkeey@googlemail.com> <f65439b7f2e5843eb18b7880ba64adb959b87c11.1296769444.git.chunkeey@googlemail.com> <AANLkTin=AxaG=bvV6pr18tZ0SpHpU21adzeHFm=gei8W@mail.gmail.com>
In-Reply-To: <AANLkTin=AxaG=bvV6pr18tZ0SpHpU21adzeHFm=gei8W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102040912.44181.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 February 2011 23:39:40 Julian Calaby wrote:
> On Fri, Feb 4, 2011 at 08:30, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > All AR9170 hardware have a 16-Bit random number generator.
> > The documentation claims the values are suitable for
> > "security keys".
> >
> > This is an early, but working version. The "throughput" is
> > around 320Kibit/s. It's slow, but it will work without
> > introducing any special offload firmware commands.
> 
> Would it not be better to cut down on the #ifdefs and move this
> functionality into a separate file?
I don't think so. Just take a look at the led code, most of it is
in a separate file but the ifdefs are still everywhere you look...

Regards,
	Christian
