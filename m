Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.msg.oleane.net ([62.161.4.8]:38277 "EHLO
	smtp08.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab3EWPrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 11:47:46 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>, <devel@lists.open80211s.org>
Subject: How to set basic rates in mesh mode?
Date: Thu, 23 May 2013 17:47:42 +0200
Message-ID: <002301ce57cc$dcaeef40$960ccdc0$@acksys.fr> (sfid-20130523_174749_771450_A8C88F2B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Is there a way to change the basic rates set in mesh mode ?
(so that broadcasts and ACKs could be sent faster)

- iw does not do this, and cfg80211 rejects NL80211_CMD_SET_BSS for mesh
interfaces, I cannot figure out another way ?

Regards
j.p. Tosoni


