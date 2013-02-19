Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:50871 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab3BSBMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 20:12:21 -0500
Date: Tue, 19 Feb 2013 05:12:20 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: txpower setting regression
In-Reply-To: <alpine.DEB.2.02.1302190349180.12894@icf.org.ru>
Message-ID: <alpine.DEB.2.02.1302190511530.15277@icf.org.ru> (sfid-20130219_021227_960090_370BBD83)
References: <alpine.DEB.2.02.1302190349180.12894@icf.org.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-23634651-1361236340=:15277"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-23634651-1361236340=:15277
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-19 04:04 +0400, Georgiewskiy Yuriy wrote linux-wireless@vger.ker...:

hm, update - on 3.8.0 all ok

GY>
GY>Hi all, there is some kind of regression with setting transmit power,
GY>hardware is warious
GY>ar9280 cards, all work as sould with compat-wireless-3.6 and
GY>compat-drivers-2013-02-13, i have modified regulatory database:
GY>
GY>iw reg get
GY>country RU:
GY>    (2402 - 2494 @ 40), (24, 23)
GY>    (5030 - 5835 @ 40), (24, 23)
GY>
GY>with compat-wireless-3.6 and compat-drivers-2013-02-13 i can change txpower
GY>in this rules,
GY>iw list show channels and it's power according to database rules:
GY>
GY>                Frequencies:
GY>                        * 2412 MHz [1] (23.0 dBm)
GY>                        * 2417 MHz [2] (23.0 dBm)
GY>                        * 2422 MHz [3] (23.0 dBm)
GY>                        * 2427 MHz [4] (23.0 dBm)
GY>                        * 2432 MHz [5] (23.0 dBm)
GY>                        * 2437 MHz [6] (23.0 dBm)
GY>                        * 2442 MHz [7] (23.0 dBm)
GY>                        * 2447 MHz [8] (23.0 dBm)
GY>                        * 2452 MHz [9] (23.0 dBm)
GY>                        * 2457 MHz [10] (23.0 dBm)
GY>                        * 2462 MHz [11] (23.0 dBm)
GY>                        * 2467 MHz [12] (23.0 dBm)
GY>                        * 2472 MHz [13] (23.0 dBm)
GY>                        * 2484 MHz [14] (23.0 dBm)
GY>
GY>but with compat-drivers 3.7.6 and 3.8-rc7 i cannot set power level, iw phy
GY>phy0 set txpower fixed 10/limit 10/iw dev dev0/etc give same error - command
GY>failed: Operation not supported (-95), and iw list give strange output like
GY>this:
GY>
GY>                Frequencies:
GY>                        * 2412 MHz [1] (20.0 dBm)
GY>                        * 2417 MHz [2] (21.0 dBm)
GY>                        * 2422 MHz [3] (21.0 dBm)
GY>                        * 2427 MHz [4] (21.0 dBm)
GY>                        * 2432 MHz [5] (21.0 dBm)
GY>                        * 2437 MHz [6] (21.0 dBm)
GY>                        * 2442 MHz [7] (21.0 dBm)
GY>                        * 2447 MHz [8] (21.0 dBm)
GY>                        * 2452 MHz [9] (21.0 dBm)
GY>                        * 2457 MHz [10] (21.0 dBm)
GY>                        * 2462 MHz [11] (20.0 dBm)
GY>                        * 2467 MHz [12] (23.0 dBm)
GY>                        * 2472 MHz [13] (23.0 dBm)
GY>		        * 2484 MHz [14] (23.0 dBm)
GY>
GY>and channel levels different on different cards.
GY>
GY>
GY>C уважением                       With Best Regards
GY>Георгиевский Юрий.                Georgiewskiy Yuriy
GY>+7 4872 711666                    +7 4872 711666
GY>факс +7 4872 711143               fax +7 4872 711143
GY>Компания ООО "Ай Ти Сервис"       IT Service Ltd
GY>http://nkoort.ru                  http://nkoort.ru
GY>JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
GY>YG129-RIPE                        YG129-RIPE

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-23634651-1361236340=:15277--
