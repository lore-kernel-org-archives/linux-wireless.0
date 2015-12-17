Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12626 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbLQNsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 08:48:41 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NZI00CX69123590@mailout2.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Thu, 17 Dec 2015 13:48:38 +0000 (GMT)
From: drivengroove@gmail.com
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Anatoly Stepanov <drivengroove@gmail.com>
Subject: [PATCH v2 0/1] staging: rtl8723au: change parameter type in
 rtl8723a_set_rssi_cmd declaration
Date: Thu, 17 Dec 2015 16:47:35 +0300
Message-id: <1450360056-12070-1-git-send-email-drivengroove@gmail.com> (sfid-20151217_144844_960685_BC8AC13C)
In-reply-to: <wrfjr3imbg5f.fsf@redhat.com>
References: <wrfjr3imbg5f.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anatoly Stepanov <drivengroove@gmail.com>

Hi, Jes!

I updated the patch, according to your idea, now "param" is passed by value.


Anatoly Stepanov (1):
  staging: rtl8723au: change parameter type in rtl8723a_set_rssi_cmd
    declaration

 drivers/staging/rtl8723au/hal/odm.c              | 2 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 6 +++---
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.1

