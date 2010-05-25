Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63301 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0EYHDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 03:03:10 -0400
Received: by wyb29 with SMTP id 29so2108050wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 00:03:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 May 2010 10:03:05 +0300
Message-ID: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
Subject: wireless-regdb: A band is missing for IL
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to http://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.29

Channels 34 - 64 are allowed in 20 Mhz in Israel. This is not what is
written in db.txt:

country IL:
         (2402 - 2482 @ 40), (N/A, 20)

This wikipedia page relies on an official page from the Israel
Ministry of the Communication.

Emmanuel Grumbach
egrumbach@gmail.com
