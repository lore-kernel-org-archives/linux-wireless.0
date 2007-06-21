Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:26593 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754301AbXFUVud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 17:50:33 -0400
Date: Thu, 21 Jun 2007 14:50:32 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [WIP] mac80211: kill mgmt interface
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <200268.51153.qm@web51411.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regarding user-space MLME and special interfaces:
mac80211 allows for multiple virtual interfaces on top of one physical =
NIC, right?=20
Can one run multiple MLME (e.g. hostapd) instances to run multiple virt=
ual master mode interfaces
for different networks? With different BSSID?
=20
-- =20
Regards
=20
       Joerg
=20





__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden S=
chutz gegen Massenmails.=20
http://mail.yahoo.com=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
