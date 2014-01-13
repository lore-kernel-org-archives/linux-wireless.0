Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35774 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaAMJas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 04:30:48 -0500
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 8C85B21184
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 04:30:47 -0500 (EST)
Message-Id: <1389605447.17065.70000145.1A7719E9@webmail.messagingengine.com> (sfid-20140113_103054_180597_B13ACAF0)
From: "Nikita N." <nikitan@operamail.com>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: brcmsmac on BCM4313: frames 11n not shown in monitor mode
Date: Mon, 13 Jan 2014 01:30:47 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All :) an issue for the maintainers of brcmsmac, or anybody who
knows.
Using module brcmsmac, when I flip my BCM4313 in monitor mode, it shows
allright all frames sent in 11b and 11g mode, but the *11n* ones are NOT
shown, maybe filtered out or not detected.
Is that a known bug?
If not, how can I set brcmsmac to show also 11n frames?
thanks :)

-- 
http://www.fastmail.fm - The way an email service should be

