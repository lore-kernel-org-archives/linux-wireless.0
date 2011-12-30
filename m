Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44495 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab1L3OPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 09:15:14 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RgdEj-0001tG-03
	for linux-wireless@vger.kernel.org; Fri, 30 Dec 2011 15:15:09 +0100
Received: from 80.12.110.204 ([80.12.110.204])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2011 15:15:08 +0100
Received: from crocromignon by 80.12.110.204 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2011 15:15:08 +0100
To: linux-wireless@vger.kernel.org
From: Jean <crocromignon@yahoo.fr>
Subject: Re: HOW TO enable UAPSD and WMM on ath9k
Date: Fri, 30 Dec 2011 14:08:15 +0000 (UTC)
Message-ID: <loom.20111230T145440-113@post.gmane.org> (sfid-20111230_151518_893195_349810AE)
References: <10052860.45456.1296639849605.JavaMail.www@wwinf1e10> <AANLkTi=sBohy=tiYJ00k5mMS2mUBRmztB9hRht1d-9js@mail.gmail.com> <AANLkTi=3L0TubSXvP2dDaKwUv9giQ21Z6pN=VvdpUPJC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

You said:

You first need to add support for uAPSD to mac80211 for drivers which
need this completely in software, and then add it to ath9k.

Sorry, but I don't understand. What do you add  to mac80211.h?
What do you add to ath9k?

Can you explain step by step how to enable UAPSD on ATH9k or other one driver
please?

I use iw like userspace. It is not possible to define uapsd parameter in  order
to set or get value like iwpriv.

This case will help many people who want to add parameter because it very
difficult fo find something.



Thanks a lot,

Jean






