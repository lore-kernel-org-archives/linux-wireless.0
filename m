Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:60474 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3CEMIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 07:08:45 -0500
Date: Tue, 5 Mar 2013 16:08:43 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Felix Fietkau <nbd@openwrt.org>
cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
In-Reply-To: <5135DBB4.5090407@openwrt.org>
Message-ID: <alpine.DEB.2.02.1303051607490.6047@icf.org.ru> (sfid-20130305_130849_632870_7341FC9A)
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org> <alpine.DEB.2.02.1303051432550.23906@icf.org.ru> <5135DBB4.5090407@openwrt.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1165063253-1362485323=:6047"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1165063253-1362485323=:6047
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-03-05 12:49 +0100, Felix Fietkau wrote Georgiewskiy Yuriy:

FF>On 2013-03-05 11:35 AM, Georgiewskiy Yuriy wrote:
FF>> On 2013-03-03 12:49 +0100, Felix Fietkau wrote linux-wireless@vger.kernel.org:
FF>> 
FF>> Hi, in my case this two patches cause throughput drop, withous it i have 50-55Mbs
FF>> with it applied only 35-40.
FF>Please show me the rate control statistics from debugfs.

in attachment

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1165063253-1362485323=:6047
Content-Type: APPLICATION/octet-stream; name=rcstats.tar.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1303051608430.6047@icf.org.ru>
Content-Description: 
Content-Disposition: attachment; filename=rcstats.tar.bz2

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
RThQkG8ZFkA=

---1051000339-1165063253-1362485323=:6047--
