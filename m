Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:54522 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBAJCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 04:02:34 -0500
Received: by an-out-0708.google.com with SMTP id d31so251215and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 01:02:31 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q) I need you help... Chip selection.
Date: Fri, 1 Feb 2008 18:02:22 +0900
Message-ID: <000101c864b1$2c840e20$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080201_090243_717256_35E04CA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Some days before, I asked a question why 3crdag675b(3com) NIC does not
support the speed of 802.11a. and then our members tried to modify ath5=
k
driver.
but, we have not solved the problems.
(when connecting two NICs(3crdag675b) to each other for ad-hoc mode -
802.11a -, connection is unstable. max bandwidth is from 2Mbps to 17Mbp=
s.)
testing tool : iperf

Our members plan to modify driver sources, mac sources and then test th=
em
with new NICs(also, we plan to make a hardware module using atheros
chipset).
But now, the 3crdag675b we bought is -.-;; so so.....

Because of these, I want to get some helps *^_^*

We want to find out new NICs using atheros chipset(AR5414). For this, s=
ome
reqirements.
1. Shuld be opened the driver sources(linux).(because, we have to modif=
y
mac sources, driver sources.)
2. Working well on LINUX machine.
3. AND NICs type SHOULD BE PCI.
4. if there's no nics using atheros chipset AR5414, recommend other
products supporting above requirements please...

anyone know about this, ^^ help us......

thank you~~~=20


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
