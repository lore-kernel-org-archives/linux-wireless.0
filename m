Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:51964 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2GTSUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 14:20:46 -0400
Date: Fri, 20 Jul 2012 22:20:42 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org
Subject: Re: [PATCH] mac80211: add extra checking for RC init upon receiving
 mesh beacon
In-Reply-To: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com>
Message-ID: <alpine.DEB.2.02.1207202219440.11352@icf.org.ru> (sfid-20120720_202050_129867_4231EEB5)
References: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-1313037924-1342808442=:11352"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-1313037924-1342808442=:11352
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-07-20 20:36 +0800, Chun-Yeow Yeoh wrote linux-wireless@vger.kernel.org:

Hi, it seems fixed issue with my emty rc_stats.

CY>Rate control statistic is flushed whenever the mesh beacon
CY>is received. This may not optimizes the performance of rate
CY>control algorithm. This patch ensures that <rate_control_
CY>rate_init> is called only if the peer's channel type is
CY>changed.


C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-1313037924-1342808442=:11352--
