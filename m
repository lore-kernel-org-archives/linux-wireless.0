Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:54812 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0LIWUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 17:20:38 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Dec 2010 14:20:17 -0800
Message-ID: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
Subject: Start dropping PCMCIA from compat-wireless for 2.6.38+
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm going to start dropping PCMCIA stuff from compat-wireless as I
don't think we have any users of it nor interest to keep backporting
it. This entails dropping drivers like orinoco, b43 PCMCIA support,
libertas, as well as bluetooth bluecard_cs, bluecard_cs, dtl1_cs,
bt3c_cs and of course CONFIG_SSB_PCMCIAHOST. If you are a user please
yell now.

 Luis
