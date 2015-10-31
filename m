Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from filter.openoffice.nl ([144.76.204.185]:57484 "EHLO
	filter.openoffice.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbbJaK3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 06:29:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by filter.openoffice.nl (Postfix) with ESMTP id D2B5D8534A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2015 11:24:20 +0100 (CET)
Received: from filter.openoffice.nl ([127.0.0.1])
	by localhost (filter.openoffice.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2JCdLhluqfm1 for <linux-wireless@vger.kernel.org>;
	Sat, 31 Oct 2015 11:24:19 +0100 (CET)
Received: from blub.net (mail.blub.net [95.97.76.243])
	by filter.openoffice.nl (Postfix) with ESMTP id 2C46C85345
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2015 11:24:19 +0100 (CET)
Received: from [10.56.54.20] (095-096-095-164.static.chello.nl [95.96.95.164])
	by blub.net (Postfix) with ESMTPSA id 014963026C2
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2015 11:24:18 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Valentijn Sessink <v@lentijn.sess.ink>
Subject: at9k: multi-ssid AP on DFS channels not working - by design?
Message-ID: <563496D2.5050005@lentijn.sess.ink> (sfid-20151031_112958_258692_90B30748)
Date: Sat, 31 Oct 2015 11:24:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

This has been asked before (by Jean-Pierre TOSONI on April 30, 2015,
"ath9k: multi-ssid AP does not work on DFS channel"), but I could not
find a reply, so I'm asking again: I found out that multi-SSID AP on DFS
channels don't work, is that by design? (I'm using OpenWrt 15.05 with
kernel 3.18.20 on a TP-Link wifi station with, apparently, an AR9580
chip - but I could be wrong on the last one).

Best regards,

Valentijn
-- 
✉ v@lentijn.sess.ink ☏ +31777777713 (31 7x7 13)
⌂ durgerdamstraat 29 zaandam
