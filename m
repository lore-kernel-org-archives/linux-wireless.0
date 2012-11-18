Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:49191 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2KRXyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 18:54:55 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 0250DD198C2
	for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 00:54:51 +0100 (CET)
Received: from zimbra4-e1.priv.proxad.net (unknown [172.20.243.154])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 5F1964B002F
	for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 00:54:14 +0100 (CET)
Date: Mon, 19 Nov 2012 00:54:13 +0100 (CET)
From: sebastien.major@free.fr
To: linux-wireless@vger.kernel.org
Message-ID: <1169888163.63483054.1353282853141.JavaMail.root@zimbra4-e1.priv.proxad.net> (sfid-20121119_005459_727105_7A95B38D)
In-Reply-To: <767233844.63481367.1353282635209.JavaMail.root@zimbra4-e1.priv.proxad.net>
Subject: Edimax EW-7612Aun does not work.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

All is said in title : my edimax refuse to start correctly.

kernel choose to load rtl8192cu and appropriate firmware but nothing : I see a reply in dmesg which says "wlan10 : link not ready".

tested on Acer laptop Core 2 duo with linux 3.6.7 freshly compiled by kpkg-buildpackage (Debian unstable).

Edimax driver are old and for i386 (32 bits).


Any doc is welcome : thanks by advance.

Best regards.
S. Major
