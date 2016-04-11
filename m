Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:7001
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbcDKPEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 11:04:40 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rfkill LED not working on HP ProBook 640 G2 (Intel Corporation
 Wireless 8260 (rev 3a))
Date: Mon, 11 Apr 2016 14:48:55 +0000
Message-ID: <1460386153.8697.18.camel@infinera.com> (sfid-20160411_170447_797069_8F122442)
Content-Type: text/plain; charset="iso-8859-15"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Got this fairly new laptop(skylake based) where the rfkill switch works. I can see the kernel(4.4.6)
bringing wifi up and down whenever I toggle rfkill, also:
~ # rfkill list
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
<Press rfkill and ...>
~ # rfkill list
0: phy0: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
1: hci0: Bluetooth
	Soft blocked: yes
	Hard blocked: no

However, the rfkill LED stays white ALL the time.

Used wifi firmware:
  iwlwifi 0000:02:00.0: loaded firmware version 16.242414.0 op_mode iwlmvm

 Jocke
