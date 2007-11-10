Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out28.alice.it ([85.33.2.28]:3905 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXKJJbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 04:31:24 -0500
Message-ID: <001001c8237a$0f0b9a20$0601a8c0@ruggiero> (sfid-20071110_093129_782614_B2D94B28)
From: "Ruggiero" <rugg.argos@tiscali.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Larry Finger" <larry.finger@lwfinger.net>
Cc: <bcm43xx-dev@lists.berlios.de>,
	"wireless" <linux-wireless@vger.kernel.org>
References: <000b01c8231a$b78c82a0$0601a8c0@ruggiero> <001001c8231c$04413d60$0601a8c0@ruggiero> <4734E1BC.1060608@lwfinger.net> <20071110002158.GB32472@tuxdriver.com>
Subject: Re: Help with wireless on Fedora 8
Date: Sat, 10 Nov 2007 10:14:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"; charset="iso-8859-1"; reply-type="original"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

here there are new informations after
upgrading the kernel,i tried to connect first with NetworkManager and then 
with
System->Administration->Network and then activating interface :



b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
Registered led device: b43-phy0:tx
Registered led device: b43-phy0:rx
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
input: Unspecified device as /class/input/input10
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized i915 1.6.0 20060119 on minor 0
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: RX AssocResp from 00:0c:41:19:2d:c1 (capab=0x1 status=0 aid=2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: disassociate(reason=3)
wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
associate state - ignored
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: deauthenticated
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: RX ReassocResp from 00:0c:41:19:2d:c1 (capab=0x1 status=0 aid=3)
wlan0: associated
wlan0: disassociate(reason=3)
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: deauthenticated
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: RX deauthentication from 00:0c:41:19:2d:c1 (reason=6)
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: authenticate with AP 00:0c:41:19:2d:c1
wlan0: RX authentication from 00:0c:41:19:2d:c1 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: associate with AP 00:0c:41:19:2d:c1
wlan0: association with AP 00:0c:41:19:2d:c1 timed out
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
authenticate state - ignored
wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
associate state - ignored
wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
associate state - ignored
wlan0: association frame received from 00:0c:41:19:2d:c1, but not in
associate state - ignored
wlan0: no IPv6 routers present

thanks u all for helping


-- 
Io utilizzo la versione gratuita di SPAMfighter per utenti privati. Sino ad ora
 ha rimosso 831 mail spam. 
 Gli utenti paganti non hanno questo messaggio nelle loro email .
 Prova gratuitamente SPAMfighter qui:http://www.spamfighter.com/lit


