Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:39302 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZC2ULq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 16:11:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 1A7D730D
	for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 21:45:41 +0200 (CEST)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
 by localhost (kso [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 30876-04 for <linux-wireless@vger.kernel.org>;
 Sun, 29 Mar 2009 21:45:37 +0200 (CEST)
Received: from [192.168.178.31] (unknown [89.246.169.68])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 2E52F9A
	for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 21:45:37 +0200 (CEST)
Message-ID: <49CFD043.6020708@tls-tautenburg.de> (sfid-20090329_221151_387129_C229915F)
Date: Sun, 29 Mar 2009 21:47:15 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compile error compat-wireless-2009-03-29
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to compile the latest compat-wireless packagev=20
(2.6.29-20327-g8f2487d) on an Ubuntu 8.10 system running linux kernel 2=
=2E6.27-12=20
I get the following error

/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/agg-t=
x.c: In=20
function =E2=80=98ieee80211_agg_splice_packets=E2=80=99:
/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/agg-t=
x.c:385:=20
error: implicit declaration of function =E2=80=98skb_queue_splice_tail_=
init=E2=80=99
make[3]: ***=20
[/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/agg-=
tx.o] Error 1
make[2]: *** [/home/stecklum/System/src/compat-wireless-2009-03-29/net/=
mac80211]=20
Error 2
make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-03=
-29] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
make: *** [modules] Error 2
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
