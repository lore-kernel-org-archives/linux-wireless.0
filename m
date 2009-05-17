Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:42252 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZEQMIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:08:23 -0400
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 8F7D7301
	for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 13:26:48 +0200 (CEST)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
 by localhost (kso [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 12074-07 for <linux-wireless@vger.kernel.org>;
 Sun, 17 May 2009 13:26:45 +0200 (CEST)
Received: from [192.168.178.37] (unknown [89.246.169.41])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 6AB8A316
	for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 13:26:44 +0200 (CEST)
Message-ID: <4A0FF4FE.1030304@tls-tautenburg.de>
Date: Sun, 17 May 2009 13:29:02 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compile error compat-wireless
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to compile the latest compat-wireless package on an Ubuntu 8.10 
64bit system running linux kernel 2.6.27-12 I get the following error

stecklum@extragalactix:~/System/src/compat-wireless-2009-05-17$ make
...
  CC [M]  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/tx.o
  CC [M]  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o
/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c: In 
function ‘ieee80211_key_alloc’:
/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:326: 
error: implicit declaration of function ‘get_unaligned_le32’
/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:328: 
error: implicit declaration of function ‘get_unaligned_le16’
make[3]: *** 
[/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o] Error 1
make[2]: *** [/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211] 
Error 2
make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-05-17] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
make: *** [modules] Error 2

Regards,

	Bringfried

