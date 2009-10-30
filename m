Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.176.58]:33668 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbZJ3TxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 15:53:23 -0400
Received: from mx38.mail.ru (mx38.mail.ru [94.100.176.52])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id 7FEB3506628
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 22:53:27 +0300 (MSK)
Received: from [94.242.37.174] (port=43384 helo=zhubr.mshome.net)
	by mx38.mail.ru with asmtp
	id 1N3xWq-0006tH-00
	for linux-wireless@vger.kernel.org; Fri, 30 Oct 2009 22:52:56 +0300
Date: Fri, 30 Oct 2009 23:00:28 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1094614475.20091030230028@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: ieee80211_tx_status: headroom too small
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello people,

I'm using compat-wireless-2009-09-14 with 2.6.25.20 and I have
recently noticed lots of these in syslog:

ieee80211_tx_status: headroom too small
ieee80211_tx_status: headroom too small
ieee80211_tx_status: headroom too small

The wireless (access point) works fine, though maybe not very
fast. However, this warning somehow bothers me. Is it important?
Does it mean something critical? Maybe I should just comment
it out in the code? I don't like syslog being filled up this
way...

Thank you.

Nikolai ZHUBR


