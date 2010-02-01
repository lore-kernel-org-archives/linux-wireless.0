Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55233 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0BAJJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 04:09:56 -0500
Received: by ewy19 with SMTP id 19so2087224ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2010 01:09:55 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 1 Feb 2010 17:09:55 +0800
Message-ID: <5135d20a1002010109s587d566bo5bd9c1aee7d081c5@mail.gmail.com>
Subject: time-out for authentication
From: fengzeheng <zehengfeng@gmail.com>
To: bzhao@marvell.com, dcbw@redhat.com, linville@tuxdriver.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, All
    our project import marvell sd8686 chipset , and we meet some
problems about authentication and connect to a D-Link AP.  first the
marvell wireless card authentication(open auth) to D-Link AP, and if
D-Link AP send authentication packet to marvell card after 1 seconds ,
then marvell wireless card doesn't send any associate message to
D-Link. and if D-Link AP response this authentication message very
quickly in mini-seconds,  then marvell wireless card will send
associate message and connect to AP. so how long  will marvell
wireless card  wait for the AP's authentication response ?
    thanks
--
Best Regards
Feng zeheng
