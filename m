Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.tutanota.de ([81.3.6.162]:38032 "EHLO w1.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752420AbeDCTJb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:09:31 -0400
Received: from w1.tutanota.de (unknown [192.168.1.162])
        by w1.tutanota.de (Postfix) with ESMTP id 108EBFB912E
        for <linux-wireless@vger.kernel.org>; Tue,  3 Apr 2018 19:09:30 +0000 (UTC)
Date: Tue, 3 Apr 2018 21:09:28 +0200 (CEST)
From: <jkon23@tuta.io>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Message-ID: <L9BuUmz--3-0@tuta.io> (sfid-20180403_210935_208237_5796D2EB)
Subject: Packet Injection in 5Ghz bands with iwlwifi devices?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Does anyone know if it is possible to inject packets
at bands above 2.4 Ghz with either the 7265NGW or the 3168NGW?=C2=A0

According to=C2=A0https://wikidevi.com/wiki/Iwlwifi <https://wikidevi.com/w=
iki/Iwlwifi>, Intel cards using the iwlwifi
driver should support packet injection. When I try to use the Intel
7265NGW or the 3168NGW I am only able to inject packets at 2.4 Ghz. Initial=
ly,
I thought that this might be an issue with the regulatory domain not gettin=
g
set correctly, but once I edited /etc/modprobe.d/iwlwifi.conf to add=C2=A0
`lar_disable=3D1` I was able to set the regulatory domain to something othe=
r than
the default 00 domain. However, I was still unable to inject packets in 5Gh=
z
bands. I have tried this using Ubuntu 16.04, Ubuntu 18.04 beta and a very r=
ecent
nightly build of Kali Linux.=C2=A0

Apologies if this is the wrong mailing list for this question.

-John
