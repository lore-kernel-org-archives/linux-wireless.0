Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35485 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbYLEFRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 00:17:33 -0500
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 149FB1CBF24
	for <linux-wireless@vger.kernel.org>; Fri,  5 Dec 2008 00:17:30 -0500 (EST)
Message-Id: <1228454249.2652.1288380409@webmail.messagingengine.com> (sfid-20081205_061749_224487_3E32D4B6)
From: "Dan E" <trg_info@mailhaven.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Subject: CRDA question
Date: Fri, 05 Dec 2008 00:17:29 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the purpose of the "intersect" program in CRDA? It builds but it
doesn't seem to be used anywhere. I also notice the CRDA source has its
own nl80211.h header file, as does the source tree for "iw". Shouldn't
userspace tools just include the sanitized kernel header from the
standard gcc include-file locations? Having multiple copies (and
versions) of nl80211.h everywhere seems like a bad idea.

Will CRDA work with AP mode? That's where my primary interest lies (I'm
writing a new driver for an as-yet unsupported chipset). I can see the
usefulness of CRDA in a laptop. I have a much harder time seeing the
benefit of a 250K application to process 3,000 bytes of data
(regulatory.bin) in an embedded AP context where filesystem space is at
a premium.

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

