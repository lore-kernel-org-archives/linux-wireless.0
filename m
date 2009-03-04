Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:36244 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZCDA6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 19:58:05 -0500
Received: by rv-out-0506.google.com with SMTP id g37so3037423rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 16:58:02 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Mar 2009 01:58:02 +0100
Message-ID: <655e2d30903031658w3e752090mdcba7c9090068393@mail.gmail.com> (sfid-20090304_015811_451856_492DD848)
Subject: MAC/PHY layer implementation
From: Rahul Jain <rahul@schmizz.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all, apologies for asking this again, but this time the question is
very specific.

I am working on a related project for my Bachelor's
thesis and would really appreciate any help that I can get in this regard. I
am supposed to develop a device driver for the IEEE 802.15.4 nanoLOC
transceiver (for Linux boards) and I have a few questions about how exactly to
go about it.
As far as I understand it, I first need a kernel stack for IEEE 802.15.4 (as
far as I understand mac80211 is the kernel stack for the IEEE 802.11 and I
would need something similar). This Kernel stack, as I understand it, would
then provide a common API for driver development.

So, I would really appreciate if some one could inform me as to what exactly
does programming this stack incorporate? Do I need to implement the PHY and
the MAC layers, and if yes, how do I go about that?

Please Help!

Thanks
Rahul Jain
