Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:44866 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802Ab0ASVTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 16:19:43 -0500
Received: from smtpauth01.csee.onr.siteprotect.com (smtpauth01.csee.onr.siteprotect.com [64.26.60.145])
	by fbr02.csee.onr.siteprotect.com (Postfix) with ESMTP id 62EC63B8267
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 15:19:42 -0600 (CST)
Received: from FrankWMillerPC (unknown [174.51.92.116])
	(Authenticated sender: frankwmiller@frankwmiller.net)
	by smtpauth01.csee.onr.siteprotect.com (Postfix) with ESMTP id 86BEE1C806B
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 15:19:07 -0600 (CST)
From: "Frank W. Miller" <frankwmiller@frankwmiller.net>
To: <linux-wireless@vger.kernel.org>
Subject: wireless for manet experiments
Date: Tue, 19 Jan 2010 14:19:07 -0700
Message-ID: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Greetings,

I'm interested in using my 802.11 interface to do some experimenting with
manet protocols.  To that end I'd like to do two things:

1) disconnect the wireless interface from the IP stack and access it
directly from user space

2) later, I'd like to interpose the Layer 2 protocol between the wireless
interface and the IP network stack.

What is the best way to go about these things?

Thanks,
FM


