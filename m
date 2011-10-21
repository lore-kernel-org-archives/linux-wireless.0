Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.srv.pl ([217.17.32.250]:40345 "EHLO mail.srv.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab1JUH5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 03:57:43 -0400
Subject: iwlagn and iwconfig
From: jarek <jarek@poczta.srv.pl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 09:25:12 +0200
Message-ID: <1319181912.28839.39.camel@jlap2.macro.local> (sfid-20111021_095747_066351_A96D6517)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

	How can I select radio channels on iwlagn (Intel Wireless-N 1030
adapter) in monitor mode ?
	I've tried to use 

iwconfig wlan0 channel NN

but it doesn't work properly. Any channel number is accepted, but is not
changed. The card is working properly, network-manager is able to find
all hotspots on all channels, so it must use some other way to make
channel hooping.

Best regards
Jarek



