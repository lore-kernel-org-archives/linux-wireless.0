Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:46147 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1C0Bpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 21:45:31 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2R1jNfs028796
	for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2011 21:45:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 0B90F1E0295
	for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2011 21:45:22 -0400 (EDT)
Message-ID: <4D8E96B5.7090707@lockie.ca>
Date: Sat, 26 Mar 2011 21:45:25 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: what does this mean
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried the 2011 03 26 compat-wireless and it gives this error when I
try a scan (it finds some networks but I know there are more).

sudo iw dev wlan0 scan | grep -i ssid

ath: timeout (100000 us) on reg 0x9c20: 0x00000000 & 0x00000001 !=
0x00000001
ath: Could not kill baseband RX

