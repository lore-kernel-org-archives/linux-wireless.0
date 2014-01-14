Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:45842 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaANNRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 08:17:05 -0500
Received: from smtp28.msg.oleane.net (smtp28.mail.priv [172.17.20.150])
	by smtp-out03.msg.oleane.net with ESMTP id s0EDH2v0018655
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 14:17:03 +0100
Received: from RD8 ([195.6.104.67]) (authenticated)
	by smtp28.msg.oleane.net (MSA) with ESMTP id s0ECuhu1006631
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 13:56:46 +0100
From: "voncken" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC mac80211] Add field in struct ieee80211_tx_info 
Date: Tue, 14 Jan 2014 13:56:42 +0100
Message-ID: <07c501cf1128$15412a70$3fc37f50$@acksys.fr> (sfid-20140114_141710_195002_47B9DE35)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to add the management of IEEE80211_RADIOTAP_RATE and
IEEE80211_RADIOTAP_MCS in radiotap parser.

To do that I need to add a flag in field flags of in struct
ieee80211_tx_info (To bypass the mac80211 RC).

The problem is all bit are used in this field. 

How I can add the new flag ?
	- I change the flags type to u64
	- I add a second flag field in the struct ieee80211_tx_info (for
exemple flags_ext)

Thanks for your help

Cedric Voncken


