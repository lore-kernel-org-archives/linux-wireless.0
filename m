Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:39912 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYLJQUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 11:20:46 -0500
Received: from f20.poczta.interia.pl (f20.poczta.interia.pl [10.217.2.20])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 1835F3D84A7
	for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 17:20:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by f20.poczta.interia.pl (Postfix) with ESMTP id 0D6EF7DC860
	for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 17:20:40 +0100 (CET)
Date: 10 Dec 2008 17:20:40 +0100
From: siamer <siamer@interia.pl>
Subject: b43 phy0 error and disconnecting
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=UTF-8
Message-Id: <20081210162041.0D6EF7DC860@f20.poczta.interia.pl> (sfid-20081210_172058_551014_EE8DF60D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 > Hello.
 > My situation is looking like that:
 > when i'm just using internet than intetnet is not disconnecting me a=
nd is
 > not b43 phy0 error but it's starting when i'm starting download some=
thing
 > than dmesg show: b43 phy0 error ( i think speed of downloads is too =
high so
 > it's disconnecting me ). And when i'm using the newest firmware=20
 > ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.=
00.00.018_us.tgz
 > (cd wrt610n_v1.00.00.018_us/release/src/wl/linux/ b43-fwcutter
 > --unsupported -w /lib/firmware/ wl.o) than internet is not disconnec=
ting me
 > but i'm still getting b43 phy0 error... Maybe You can check this fir=
mware
 > and this from linuxwireless and see what is the difference ?=20
 >=20
 >=20
 > PS. This is my topic on forum about it (maybe it will help You to fi=
x it)=20
 > http://hack.mypclinuxos.com/index.php?topic=3D721.0
 >=20
 > siamer
 >=20
 >=20


Tysiace zabawnych wierszyk=F3w.Dodaj swoj
Sprawdz >>> http://link.interia.pl/f1fcd

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
