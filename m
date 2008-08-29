Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50835 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYH2LUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 07:20:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: sHittmeyer <hittmeyer@corscience.de>
Subject: Re: building compat-wireless-2.6
Date: Fri, 29 Aug 2008 13:20:21 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <48B7B84F.9030709@corscience.de>
In-Reply-To: <48B7B84F.9030709@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200808291320.22188.mb@bu3sch.de> (sfid-20080829_132110_072674_8506CD1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 August 2008, sHittmeyer wrote:
> Hello,
> I just copied the actual git repository of compat-wireless-2.6 and wa=
nt=20
> to compile it for a kernel 2.6.23 which is patched for a =B5C so im f=
ixed=20
> on that Kernel.
>=20
> I changed the Makefile so I can Cross_Compile the compat-wireless-2.6=
=20
> for that Kernel but in the Makefile there is a script used before=20
> compile which checks and inits the config. The problem is, it doesn't=
=20
> work. I immediately get the message:
> =20
> ---> cat: /home/stefan/compat-wireless-2.6/compat-release: No such fi=
le=20
> or directory
> ---> cat: /home/stefan/compat-wireless-2.6/compat-release: No such fi=
le=20
> or directory
>       ./scripts/gen-compat-autoconf.sh config.mk >=20
> include/linux/compat_autoconf.h
>       ./scripts/check_config.sh: line 12:=20
> include/linux/compat_autoconf.h: No such file or directory
>       cat: /home/stefan/compat-wireless-2.6/compat-release: No such f=
ile=20
> or directory

I guess you need to install your kernel sourcecode.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
