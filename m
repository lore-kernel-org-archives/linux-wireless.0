Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sesbmg22.ericsson.net ([193.180.251.48]:58891 "EHLO
        sesbmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbeHaRG4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:06:56 -0400
From: Jakov Simunic <jakov.simunic@ericsson.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Build iw for 32bit ARM
Date: Fri, 31 Aug 2018 12:44:28 +0000
Message-ID: <HE1PR0702MB38043B23810E618B01413959980F0@HE1PR0702MB3804.eurprd07.prod.outlook.com> (sfid-20180831_145937_381575_481E6DFC)
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I am working on an embedded project which uses an armv7l architecture, whic=
h is a 32bit platform, and I am trying to compile iw-4.9 for it, and I don'=
t know how to compile it for 32bit arches.
Tried adding -m32 to the CFLAGS, everything passes the build except the iw =
binary, which says:

iw.o: could not read symbols: File in wrong format
collect2: ld returned 1 exit status
make: *** [iw] Error 1

Could you please offer any help/advices on how to compile iw for 32bit arch=
es?
--
Lijep pozdrav / Best regards
Jakov =A9imuni=E6
