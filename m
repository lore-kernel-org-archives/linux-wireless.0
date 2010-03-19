Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33658 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0CSSkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 14:40:42 -0400
Received: by bwz1 with SMTP id 1so300469bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 11:40:40 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
References: <4BA266FB.1080507@lwfinger.net>
	<1268945580.4005.15.camel@jlt3.sipsolutions.net>
	<4BA296BA.7000502@lwfinger.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 19 Mar 2010 20:40:38 +0200
In-Reply-To: <4BA296BA.7000502@lwfinger.net> (Larry Finger's message of "Thu\, 18 Mar 2010 16\:10\:18 -0500")
Message-ID: <87634scfyx.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> It comes from the SPROM, which is missing in the devices in
> question. Broadcrap wanted to save a few pennies.

It's just only about the cost, it's also about the size. Most probably
in the future there will be even more designs like this. In the
embedded side there has been such devices for few years now.

-- 
Kalle Valo
