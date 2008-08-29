Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYH2Iu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 04:50:26 -0400
Received: from [192.168.0.136] (pc-029 [192.168.0.136])
	by corscience.de (Postfix) with ESMTP id AD21C51BA0
	for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 10:50:24 +0200 (CEST)
Message-ID: <48B7B84F.9030709@corscience.de> (sfid-20080829_105030_182285_E68530D5)
Date: Fri, 29 Aug 2008 10:50:23 +0200
From: sHittmeyer <hittmeyer@corscience.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: building compat-wireless-2.6
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I just copied the actual git repository of compat-wireless-2.6 and want=
=20
to compile it for a kernel 2.6.23 which is patched for a =B5C so im fix=
ed=20
on that Kernel.

I changed the Makefile so I can Cross_Compile the compat-wireless-2.6=20
for that Kernel but in the Makefile there is a script used before=20
compile which checks and inits the config. The problem is, it doesn't=20
work. I immediately get the message:
=20
---> cat: /home/stefan/compat-wireless-2.6/compat-release: No such file=
=20
or directory
---> cat: /home/stefan/compat-wireless-2.6/compat-release: No such file=
=20
or directory
      ./scripts/gen-compat-autoconf.sh config.mk >=20
include/linux/compat_autoconf.h
      ./scripts/check_config.sh: line 12:=20
include/linux/compat_autoconf.h: No such file or directory
      cat: /home/stefan/compat-wireless-2.6/compat-release: No such fil=
e=20
or directory

where do I get this file? oder how do I generate it?

Thanks a lot for your help :)
Stefan Hittmeyer

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
