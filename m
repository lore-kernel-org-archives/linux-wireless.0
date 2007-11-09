Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42888 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbXKIWj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:39:58 -0500
Message-ID: <4734E1BC.1060608@lwfinger.net> (sfid-20071109_224005_651247_DC1AE152)
Date: Fri, 09 Nov 2007 16:39:56 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Ruggiero <rugg.argos@tiscali.it>
CC: bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Help with wireless on Fedora 8
References: <001e01c82162$864cc970$0601a8c0@ruggiero><4731FE46.1060403@lwfinger.net><003701c82179$da3f4c80$0601a8c0@ruggiero><47329750.7080505@lwfinger.net><000601c821dd$09fc0720$0601a8c0@ruggiero><473330FF.4090605@lwfinger.net><000601c82225$7bc63220$0601a8c0@ruggiero><1194555637.25768.7.camel@dv><000001c822ce$cb1b9910$0601a8c0@ruggiero><47348492.3070605@lwfinger.net><000301c822f3$73dbef90$0601a8c0@ruggiero><4734973D.4060703@lwfinger.net><000301c82301$eafbd050$0601a8c0@ruggiero><4734AF07.5040003@lwfinger.net><000301c8230e$6880b980$0601a8c0@ruggiero><4734CCFA.1020504@lwfinger.net><000301c82315$f1d71830$0601a8c0@ruggiero><4734D328.20106@lwfinger.net> <000b01c8231a$b78c82a0$0601a8c0@ruggiero> <001001c8231c$04413d60$0601a8c0@ruggiero>
In-Reply-To: <001001c8231c$04413d60$0601a8c0@ruggiero>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I need some Fedora help. This new b43 user is having problems making a connection. He has a b-only
AP of unspecified make with no encryption. He is using F8 with the default kernel (I think). He has
done the following:

Ruggiero wrote:
> i used "system->adminstration>Network" and i configurated everything from 
> there...and the clicking on "activate wlan0" for a while my access point 
> communicate and in the log i see that it's connected... here are outputs:
> if i use NetworkManager i see it's connecting...but after a while i get the 
> message "disconnected"

Tail of dmesg:

> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authenticate with AP 00:0c:41:19:2d:c1
> wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
> wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> authenticate state - ignored
> wlan0: RX disassociation from 00:0c:41:19:2d:c1 (reason=4)

All the b43 messages are normal. He sees the AP with a scan, but never authenticates. Any suggestions?

Larry
