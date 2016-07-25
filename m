Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33800 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbcGYH0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 03:26:49 -0400
Received: by mail-yw0-f193.google.com with SMTP id j12so11088537ywb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 00:26:48 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 25 Jul 2016 12:56:28 +0530
Message-ID: <CABPxzY+na77=379E2tRDnbDzE=LOrz9ObahLTLoBTg+hhd8DBw@mail.gmail.com> (sfid-20160725_092653_306177_F6F953C7)
Subject: [RFD] mac80211: Handling local operating class in (E)CSA
To: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Some AP's use local operating class in (E)CSA IE's. Currently
mac80211 fails the parsing of those IE's and results in a
disconnection.

What is the best way to add support for local operating classes?

a) Maintaining a per country operating class table in cfg80211

b) Embed operating class info in regdb.txt (crda)

c) Remove the usage of band to calculate frequency? I dont know
of a generic formula to calculate this across bands. So not possible.


-- 
Thanks,
Regards,
Chaitanya T K.
