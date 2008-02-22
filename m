Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:4661 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYBVBfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 20:35:51 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1169272ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 17:35:50 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q : zd1211 vendor driver with 802.11a ad-hoc
Date: Fri, 22 Feb 2008 10:35:41 +0900
Message-ID: <000301c874f3$3e76b0e0$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080222_013556_643880_C9AEFDE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello~ friends~

recently, we've tested various wlan nics : atheros 5414, zydas 1211b,
ralink 2561 (and more)

at the beginning, we did plan to modify the drv source and mac source.
but because we did not enough time, we've been testing some nics instea=
d of
that.

until now,we've known :

1. atheros 5414 : compat-driver - support 802.11a with ad-hoc but happe=
ned
packet loss.
                          madwifi-driver - support 802.11a with ad-hoc =
and
no packet loss, but distance between two wlan nics is too short.(we are
testing 100m to more than 500m but this driver was disconnected in 40m)

2. zydas 1211b : kernel driver - not support 802.11a(X)
                         vendor driver - I can see the list of 5.xxGhz
channel but it was some strange, and it was not configured 802.11a with=
 ad-
hoc

3. ralink 2561 : it's coming ....^^ after one week


Hence, at this time, I want to know the difference of two atheros drive=
r.
if compat-driver does not happen packet loss, we want to atheros chipse=
t.
And in using zydas vendor driver, how can we use 802.11a mode with ad-h=
oc?

and ralink 2561 later......


thanks.




--
--
Have a Wonderful Day~~!!
=B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
yhkim@corebell.co.kr
cs010101@gmail.com
+82-42-863-0340
+82-10-6753-0987
HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
Daejon,  Republic of Korea
305-701

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
