Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ctb-mesg8.saix.net ([196.25.240.78]:56561 "EHLO
	ctb-mesg8.saix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYGJKDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 06:03:25 -0400
Received: from atlantis.local.uls.co.za (dsl-146-147-234.telkomadsl.co.za [165.146.147.234])
	by ctb-mesg8.saix.net (Postfix) with ESMTP id 44F7518FF
	for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 10:58:02 +0200 (SAST)
Received: from [192.168.42.123]
	by atlantis with esmtp (Exim 4.69)
	(envelope-from <chris@sabest.co.za>)
	id 1KGryU-0007VM-HK
	for linux-wireless@vger.kernel.org; Thu, 10 Jul 2008 10:58:02 +0200
From: Chris Calitz <chris@sabest.co.za>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Jul 2008 10:58:02 +0200
Message-Id: <1215680282.6376.5.camel@chris-laptop> (sfid-20080710_120329_387954_007A8DBC)
Mime-Version: 1.0
Subject: Compilation Problem
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everyone

I'm currently running ubuntu hardy 8.04 and struggling with default
iwl3945 driver dropping connection randomly and needing me to disable
and enable before it comes back up.=20

I have found that the compact-wireless driver apparently fixes this
issue but when I try to build this driver I get the following errors.

=20

/home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/ma=
c80211_hwsim.c: In function =E2=80=98init_mac80211_hwsim=E2=80=99:
/home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/ma=
c80211_hwsim.c:433: error: implicit declaration of function =E2=80=98de=
vice_create_drvdata=E2=80=99
/home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/ma=
c80211_hwsim.c:434: warning: assignment makes pointer from integer with=
out a cast
make[3]: ***
[/home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/m=
ac80211_hwsim.o] Error 1
make[2]: ***
[/home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/chris/wireless/compat-wireless-2008-07-10]
Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
make: *** [modules] Error 2


Can anybody help met to get this working?

Thanks
Chris

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
