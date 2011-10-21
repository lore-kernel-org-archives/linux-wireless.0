Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64184 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1JUVJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 17:09:41 -0400
Received: by ywf7 with SMTP id 7so4251091ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 14:09:41 -0700 (PDT)
From: George Nychis <gnychis@gmail.com>
Mime-Version: 1.0 (1.0)
Date: Fri, 21 Oct 2011 17:09:41 -0400
Message-ID: <2764633066252075767@unknownmsgid> (sfid-20111021_230951_085122_1B23E4BE)
Subject: Any wireless cards with this debug capability?
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Eric Rozner <erozner@cs.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are finding that under certain scenarios, various WiFi cards
(Atheros, Intel, ...) fail to decode incoming packets for certain
periods of time on the order of 5->20ms. We are trying to enable a
low-latency wireless link in which losses during this window break our
requirement. A retransmission would essentially be too late.

During this period, we are trying to determine the reason for loss.
Whether it is fading, improper tuning of AGC, failure to account for
frequency offset, etc. Ideally, what we would like to know is whether
the card *tried* to acquire the carrier and if so, where it failed. I
have noticed several Atheros kernel debug counters which show things
such as a PHY error, but it's not clear at what stage it failed.

Are there any firmwares or drivers paired with off the shelf 802.11
cards which would be good for trying to debug this?

Thanks!
George
