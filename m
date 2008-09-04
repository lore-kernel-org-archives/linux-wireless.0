Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:46585 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYIDPkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2008 11:40:20 -0400
Received: from [172.16.4.205] (zmk199.eit.uni-kl.de [131.246.73.199])
	by mailgw1.uni-kl.de (8.13.8/8.13.8/Debian-3) with ESMTP id m84FPQfD020226
	for <linux-wireless@vger.kernel.org>; Thu, 4 Sep 2008 17:25:26 +0200
Subject: minimum payload size for FEC
From: Thomas Ilnseher <illth@gmx.de>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 04 Sep 2008 17:25:26 +0200
Message-Id: <1220541926.17106.46.camel@pcmik05.zmk.uni-kl.de> (sfid-20080904_174027_932095_32D01E62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry Guys,

I'm too lazy, I know it! But please don't respond with RTFM and the
such, thx! Reading a standard is a huge pain in the A**, so I hope
somebody knows the answer already.

So here is my question:

Is there any situation where the payload to the Viterbi FEC is less than
256 bits (= 32 bytes) ? (ie. a beacon and such stuff?)

It can't be the case for an IP packet (IP header + 2 MAC addresses = 32
bytes)

This matters only for the ofdm modulation of agn, no b, no wired
TI-mode.

Thank you in advance! 

Tom.

PS: plz CC my email-address.
-- 
Thomas Ilnseher <illth@gmx.de>

