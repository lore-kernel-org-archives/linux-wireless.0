Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n2a.bullet.in.yahoo.com ([202.43.219.19]:48164 "HELO
	n2a.bullet.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750737AbYISFJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 01:09:57 -0400
Date: Fri, 19 Sep 2008 10:39:54 +0530 (IST)
From: Amit Sood <as22_2000@yahoo.com>
Subject: Problem compiling compat-wireless
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <959954.87694.qm@web95013.mail.in2.yahoo.com> (sfid-20080919_071013_816200_607A9146)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recently downloaded the compat-wireless & was trying to compile it on l=
inux-2.27-rc6 kernel. During the compilation I'm getting frollowing err=
or:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/usr/src/compat-wireless-2008-09-19/net/mac80211/rx.c: In function =E2=80=
=98ieee80211_frame_allowed=E2=80=99:
/usr/src/compat-wireless-2008-09-19/net/mac80211/rx.c:1196: error: =E2=80=
=98ETH_P_PAE=E2=80=99 undeclared (first use in this function)
/usr/src/compat-wireless-2008-09-19/net/mac80211/rx.c:1196: error: (Eac=
h undeclared identifier is reported only once
/usr/src/compat-wireless-2008-09-19/net/mac80211/rx.c:1196: error: for =
each function it appears in.)
make[3]: *** [/usr/src/compat-wireless-2008-09-19/net/mac80211/rx.o] Er=
ror 1
make[2]: *** [/usr/src/compat-wireless-2008-09-19/net/mac80211] Error 2
make[1]: *** [_module_/usr/src/compat-wireless-2008-09-19] Error 2
make[1]: Leaving directory `/storage/usr/src/linux-2.6-orig'
make: *** [modules] Error 2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

kindly assist.

regards,

-amit-


      Check out the all-new face of Yahoo! India. Go to http://in.yahoo=
=2Ecom/

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
