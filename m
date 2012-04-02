Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.ust.hk ([143.89.13.11]:50648 "EHLO mx3.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab2DBSqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 14:46:35 -0400
Received: from sqmail.ust.hk (sqmail3.ust.hk [143.89.15.19])
	by mx3.ust.hk (8.13.8/8.13.8) with ESMTP id q32IkU6Q090636
	for <linux-wireless@vger.kernel.org>; Tue, 3 Apr 2012 02:46:31 +0800 (HKT)
Message-ID: <50291.14.198.51.63.1333392391.squirrel@sqmail.ust.hk> (sfid-20120402_204639_860184_F51FABA2)
Date: Tue, 3 Apr 2012 02:46:31 +0800 (HKT)
Subject: About sending frame with mac80211
From: "Cheung Hiu Fung" <phjay@ust.hk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

  I am new to mac80211 and I try frame injections with ar5418 chipset right
now. I used raw socket programming,libpcap,netlink library and
successfuly do some injection. we expect 802.11g to be 54mbps and we
only get about 1-2mbps. The speed is quiet low and we could like to take
care some features (i.e no ack, rate control as well) for research
purpose in order to improve low layer transmission speed. Basically I
learn how to ride the ack features by modifying the
mac80211 layer.

  May I ask is that possible to access mac80211 kernel function to do some
frame injection? I want the datalink layer packet (no tcp/udp and ip
protocol)to be transmitted in wireless ad-hoc network. The closest one i
got is to use libpcap for radiotap injection but it can only be done in
monitor mode and the speed is the worst among all injection tools. I
read the following link and still not quiet sure how it works (tx and rx
process are blank for this doc).

http://docs.blackfin.uclinux.org/kernel/generated/mac80211/index.html

  I want to try the mac80211 tracer but I just cannot run it in my ubuntu
computer. I search the related information in internet and it seems not
many people work for this injection. Any hints will be appreciated.

Jay


