Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35804 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcFPKKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 06:10:30 -0400
Received: by mail-vk0-f45.google.com with SMTP id j2so66546868vkg.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 03:10:30 -0700 (PDT)
MIME-Version: 1.0
From: Majid Ashoori <majid.it@gmail.com>
Date: Thu, 16 Jun 2016 14:40:29 +0430
Message-ID: <CADpKk60njba2Y7NNCwVSSBS+eeFP3zt7zLqA3pnjKuo=n5ozqA@mail.gmail.com> (sfid-20160616_121034_534195_C3B7A027)
Subject: Getting signal strength of a received packets
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,
I am using OCB mode based on ath9k driver for my wireless connections
between different nodes. In this mode there is no BS or established
connection to analyze the signal strength of BS. Thus, I need to know
the signal strength of received packets in my user-space application
to do some calculation based on that.

So, here is the question: how can I get signal strength of a received
packet in a user-space application? I reached to the point that it may
be performed via cfg80211 or nl80211 and I check them but I am not
sure how exactly I can get that.

Thank you in advance,
Bests,
Majid.
