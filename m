Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out19.alice.it ([85.33.2.19]:1160 "EHLO
	smtp-out19.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab0EDP2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 11:28:50 -0400
Subject: [Fwd: USB AP card and/or rt2870 issue]
From: GNUtoo <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-9GkAgqU+th6EJJXhYcO9"
Date: Tue, 04 May 2010 17:28:43 +0200
Message-ID: <1272986923.2486.45.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9GkAgqU+th6EJJXhYcO9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

hi, I sent the following mail(attached) to the hostapd mailing list,but
Now I think It's a driver issue.
Is it possible to make an access point with a rt2870 card.
Does the driver support it?
I don't have much hope for now as it is a staging driver...and it
displayed a warning about that in dmesg...

Denis.


--=-9GkAgqU+th6EJJXhYcO9
Content-Disposition: inline
Content-Description: Forwarded message - USB AP card and/or rt2870 issue
Content-Type: message/rfc822

Return-Path: <hostap-bounces@lists.shmoo.com>
X-Original-To: GNUtoo@no-log.org
Delivered-To: GNUtoo@no-log.org
Received: from maxx.maxx.shmoo.com (maxx.shmoo.com [205.134.188.171])
 (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (Client CN
 "maxx.shmoo.com", Issuer "CA Cert Signing Authority" (not verified)) by
 no-log.org (Postfix) with ESMTPS id 868C637E44 for <GNUtoo@no-log.org>;
 Sat, 24 Apr 2010 20:50:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by maxx.maxx.shmoo.com
 (Postfix) with ESMTP id 49EBE9C124; Sat, 24 Apr 2010 14:50:11 -0400 (EDT)
X-Virus-Scanned: amavisd-new at maxx.shmoo.com
Received: from maxx.maxx.shmoo.com ([127.0.0.1]) by localhost
 (maxx.shmoo.com [127.0.0.1]) (amavisd-new, port 10024) with ESMTP id
 6R07ESH6i2wY; Sat, 24 Apr 2010 14:50:11 -0400 (EDT)
Received: from maxx.shmoo.com (localhost [127.0.0.1]) by
 maxx.maxx.shmoo.com (Postfix) with ESMTP id DD7DD9C150; Sat, 24 Apr 2010
 14:50:06 -0400 (EDT)
X-Original-To: mailman-post+hostap@maxx.shmoo.com
Delivered-To: mailman-post+hostap@maxx.shmoo.com
Received: from localhost (localhost [127.0.0.1]) by maxx.maxx.shmoo.com
 (Postfix) with ESMTP id 8D0779C155 for
 <mailman-post+hostap@maxx.shmoo.com>; Sat, 24 Apr 2010 14:50:05 -0400 (EDT)
X-Virus-Scanned: amavisd-new at maxx.shmoo.com
Received: from maxx.maxx.shmoo.com ([127.0.0.1]) by localhost
 (maxx.shmoo.com [127.0.0.1]) (amavisd-new, port 10024) with ESMTP id
 C1Q4oIS8nw5k for <mailman-post+hostap@maxx.shmoo.com>; Sat, 24 Apr 2010
 14:49:59 -0400 (EDT)
Received: from smtp-out110.alice.it (smtp-out110.alice.it [85.37.17.110])
 by maxx.maxx.shmoo.com (Postfix) with ESMTP id 865139C124 for
 <hostap@lists.shmoo.com>; Sat, 24 Apr 2010 14:49:59 -0400 (EDT)
Received: from FBCMMO03.fbc.local ([192.168.68.197]) by
 smtp-out110.alice.it with Microsoft SMTPSVC(6.0.3790.3959);  Sat, 24 Apr
 2010 20:49:57 +0200
Received: from FBCMCL01B01.fbc.local ([192.168.69.82]) by
 FBCMMO03.fbc.local with Microsoft SMTPSVC(6.0.3790.3959);  Sat, 24 Apr 2010
 20:49:57 +0200
Received: from [192.168.1.116] ([80.117.39.139]) by FBCMCL01B01.fbc.local
 with Microsoft SMTPSVC(6.0.3790.3959); Sat, 24 Apr 2010 20:49:57 +0200
Subject: USB AP card and/or rt2870 issue
From: GNUtoo <GNUtoo@no-log.org>
To: hostap@lists.shmoo.com
Date: Sat, 24 Apr 2010 17:51:41 +0200
Message-ID: <1272124301.2536.18.camel@gnutoo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-OriginalArrivalTime: 24 Apr 2010 18:49:57.0234 (UTC)
 FILETIME=[EF68AD20:01CAE3DE]
X-BeenThere: hostap@lists.shmoo.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: HostAP Project <hostap.lists.shmoo.com>
List-Unsubscribe: <http://lists.shmoo.com/mailman/listinfo/hostap>,
 <mailto:hostap-request@lists.shmoo.com?subject=unsubscribe>
List-Archive: <http://lists.shmoo.com/pipermail/hostap>
List-Post: <mailto:hostap@lists.shmoo.com>
List-Help: <mailto:hostap-request@lists.shmoo.com?subject=help>
List-Subscribe: <http://lists.shmoo.com/mailman/listinfo/hostap>,
 <mailto:hostap-request@lists.shmoo.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: hostap-bounces@lists.shmoo.com
Errors-To: hostap-bounces@lists.shmoo.com
Content-Transfer-Encoding: 7bit

hi,I'm thinking about replacing my pentium III 500 router with something
like a sheevaplug.
The sheevaplug-like hardware do not have a pci slot or a wireless card
supported that can do access point(if they have one(depend on the
versions)).

So I'm looking for an usb card that can do AP

Someone wanted the exact same thing than me,but for other kind of
embedded devices.he tested a rt8070 and hostap displayed a line with the
ESSID,but the access point essid didn't appear when another computer
scanned it,association was also impossible.

I bought a card with the same chipset.
with my distribution(based on ubuntu hardy) I had the same results.

But...

I wanted and planed to try wireless-compat,libnl2,and hostapd from git:
(that's why I bought it,I was thinking that I could make it work)
here are the results:

With a card that does not support AP mode:
root@gnutoo-desktop:/usr/local/bin# LD_LIBRARY_PATH=/usr/local/lib/
hostapd -ddd /usr/local/etc/hostapd.conf 
Configuration file: /usr/local/etc/hostapd.conf
nl80211: Add own interface ifindex 11
nl80211: Failed to set interface 11 to mode 3: -95 (Operation not
supported)
nl80211: Failed to set interface 11 to mode 3: -95 (Operation not
supported)
nl80211: Interface mode change to 3 from 0 failed
nl80211: Failed to set interface wlan2 into AP mode
nl80211 driver initialization failed.
ELOOP: remaining socket: sock=4 eloop_data=0x8c26718 user_data=0x8c26bf8
handler=0x8072580
ELOOP: remaining socket: sock=6 eloop_data=0x8c286e8 user_data=(nil)
handler=0x807be40

With the rt2870 card:
root@gnutoo-desktop:/usr/local/bin# LD_LIBRARY_PATH=/usr/local/lib/
hostapd -ddd /usr/local/etc/hostapd.conf 
Configuration file: /usr/local/etc/hostapd.conf
nl80211: Register Action command failed: ret=-19 (No such device)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 10
nl80211: Failed to set interface 10 to mode 3: -19 (No such device)
nl80211: Failed to set interface 10 to mode 3: -19 (No such device)
nl80211: Interface mode change to 3 from 0 failed
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.
ELOOP: remaining socket: sock=4 eloop_data=0x9fca718 user_data=0x9fcabf8
handler=0x8072580
ELOOP: remaining socket: sock=6 eloop_data=0x9fcc6e8 user_data=(nil)
handler=0x807be40

here's the configuration(interface was changed between the 2 cards)

interface=wlan0
driver=nl80211
ssid=ralink
channel=2
hw_mode=g

here are the version used:
hostapd: 		0b86f67a2970403d1b1b6d34ce49f5485ef5dbb3
libnl2: 		d378220c96c3c8b6f27dca33e7d8ba03318f9c2d
compat-wireless:        compat-wireless-2010-04-23.tar.bz2

here is the config of hostapd compilation:

root@gnutoo-desktop:~/wireless/hostap/hostapd# cat .config | sed
's/#.*//' | sed '/^$/d'
CONFIG_DRIVER_NL80211=y
LIBNL=/usr/local
CFLAGS += -I$(LIBNL)/include
LIBS += -L$(LIBNL)/lib
CONFIG_LIBNL20=y
CONFIG_IAPP=y
CONFIG_RSN_PREAUTH=y
CONFIG_PEERKEY=y
CONFIG_EAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_TLS=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_GTC=y
CONFIG_EAP_TTLS=y
CONFIG_PKCS12=y
CONFIG_IPV6=y

I started to post here because I'm not shure if it's an hostap,a libnl2
or a wireless-dev problem.

I hope the problem can be fixed(or that after time(and effort of the
developers) it would be fixed,so I would only have to wait,I hope not
too long),else I would need to search for another card.

Denis.

_______________________________________________
HostAP mailing list
HostAP@lists.shmoo.com
http://lists.shmoo.com/mailman/listinfo/hostap

--=-9GkAgqU+th6EJJXhYcO9--

