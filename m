Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2BMNYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 08:24:07 -0500
Received: by bkcjm19 with SMTP id jm19so4527208bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 05:24:05 -0800 (PST)
Message-ID: <4F390ED3.8010400@openwrt.org> (sfid-20120213_142411_692746_CE66A203)
Date: Mon, 13 Feb 2012 14:23:31 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	gwingerde@gmail.com, ivdoorn@gmail.com
Subject: Poor RT2880 performance
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am playing with a RT2880-F based AP, with a N connected station, in a 
residential environment.

I could not get more than 26Mbits/sec TCP performance using iperf on 
both sides, changing to a busier channel even made the performance drop 
down to 5Mbits/sec, and remained like this.

Let me know if you need more informations like survey dumps etc ... it 
does not seem like we are hitting the CPU bounds here, I can also attach 
the EEPROM in case it helps.

Thank you very much.
--
Florian
