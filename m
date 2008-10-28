Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:64370 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYJ1Hsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 03:48:55 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2566658rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 00:48:54 -0700 (PDT)
Message-ID: <efe7343f0810280048j57158020n67176d7a56f0bbea@mail.gmail.com> (sfid-20081028_084900_260068_40D60D86)
Date: Tue, 28 Oct 2008 07:48:54 +0000
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Thorsten Leemhuis" <fedora@leemhuis.info>
Subject: Re: rtl2860 driver in mainline?
Cc: "Greg KH" <greg@kroah.com>, rt2400-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <4906B944.4010105@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081028004915.GA3442@kroah.com> <4906B944.4010105@leemhuis.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Tue, Oct 28, 2008 at 07:03, Thorsten Leemhuis <fedora@leemhuis.info> wrote:
> On 28.10.2008 01:49, Greg KH wrote:
>>
>> So, on my quest to suck up every out-of-tree driver and get it into the
>> main kernel tree (drivers/staging/ to start with), I've been pointed at
>> the rtl2860 driver.
>
> Does it really make sense to include a driver when a different one for
> mainline inclusion is being actively developed? It might give some
> developers the impression that it's worth spending time improving the
> rtl2860/2870 drivers -- which might be wasted time in the end.

Is it just me or you are suggesting we use the Ralink supplied driver,
with its own wireless stack, rather then work with the rt2x00 team?

Do we really want that again (several wireless stacks)?

>> Does anyone know of a "cleaned up" version of this driver that is
>> newer/better than the one on ralink's web site?  I found the
>> 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
>> start with that if no one else has yet.
>>
>> Any pointers are appreciated.
>
> You can find a few patches (needed for 2.6.26 and 2.6.27 iirc; not sure if
> they are enough to make it work on current mainline) for both rt2860 and
> rt2870 in CVS for RPM Fusion:
>
> http://cvs.rpmfusion.org/viewvc/rpms/rt2860-kmod/devel/?root=free
> http://cvs.rpmfusion.org/viewvc/rpms/rt2870-kmod/devel/?root=free

This seems to be only a set of 'mixed-up-lets-just-use-ralink-code' patchset.

>
> HTH
>
> CU
> knurd

p.s. I apologize in advance if I misunderstood the meaning of the
original reply.

Luis Correia
rt2x00 project admin
