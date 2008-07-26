Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:59587 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYGZOMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 10:12:52 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 99E8F28AFC1B
	for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 16:12:51 +0200 (CEST)
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 4ABC832A83A
	for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 16:11:41 +0200 (CEST)
Received: from localhost (ble59-5-82-233-204-229.fbx.proxad.net [82.233.204.229])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 21B4D32A841
	for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 16:11:41 +0200 (CEST)
Date: Sat, 26 Jul 2008 16:11:40 +0200
From: =?UTF-8?B?Q8OpZHJpYw==?= Auger <cedric@grisbi.org>
To: linux-wireless@vger.kernel.org
Subject: iwl3945 slow for downloading
Message-ID: <20080726161140.59041730@grisbi.org> (sfid-20080726_161258_642240_E9ED92DD)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello
i've a problem for iwl3945 and didn't find on google something about
that. i have the kernel 2.6.26 and use the kernel's driver. when i was
with the ipw3945, i could download with a speed of at least 600k/s, and
sometimes more.
it's some time i changed for iwl3945 and didn't see some difference
exept it works better in several ways, but some times ago, i noticed
that dowloading big images was slow.
i checked to transfer a file between 2 computer by wifi, and the
download is limited to about 130-140k/s. when i plug a cable, i go
directly to 900kb/s.
i tried to remove all debugging options in the kernel for that driver,
but no differences.
i don't see any difference when i go on website, it's only the max
download speed wich cannot go more thant 130kb/s.
i have a dell m1710, with intel 3945ABG
my lspci :
0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
i'm on debian sid, with a 2.6.26 kernel and use wpa supplicant
i have networkmanager as daemon, but use /etc/network/interfaces and
ifup to manage my wifi
i have no error on my syslog, daemon.log, wpa_supplicant log,
i don't know if you need some extra informations about my system.
thanks
cedric
