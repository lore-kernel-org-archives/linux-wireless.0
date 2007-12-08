Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:54431 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXLHUWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 15:22:42 -0500
Received: by py-out-1112.google.com with SMTP id u77so2422440pyb
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2007 12:22:39 -0800 (PST)
Message-ID: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com> (sfid-20071208_202245_906816_9B3A96FA)
Date: Sat, 8 Dec 2007 14:22:37 -0600
From: "John H." <mistamaila@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: b43 continues to have issue with APs at times
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have this problem at two different locations with two different
access points.  2.6.23.1 kernel, and sometimes until I actually power
down the AP and restart it, wpa_supplicant and such just times out on
the AP.

Any ideas?
