Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:26281 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYCEPe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 10:34:56 -0500
Received: by rv-out-0910.google.com with SMTP id k20so933173rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 07:34:55 -0800 (PST)
Message-ID: <84ac67910803050734t1386a8edx39eb7133c909d9bb@mail.gmail.com> (sfid-20080305_153500_718605_0032C9C2)
Date: Wed, 5 Mar 2008 15:34:55 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: B43 will not associate
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200803051517.31919.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com>
	 <200803042047.35710.mb@bu3sch.de>
	 <84ac67910803041413s510c5513k25f77762b0e70d@mail.gmail.com>
	 <200803051517.31919.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  It's impossible to debug something, if you don't fscking
>  tell me your testbed setup and what's going on/wrong.

Well you don't get what you don't ask for.

I assume testbed means my hardware.

x86_64 proc., runnig 2.6.24-rt3 (in 64bit) with gentoo userland
(64bit). The card in question is a pci card.

I have tried on 2.6.24 vanilla and the association problem is exactly
the same. The card can see the AP fine but simply won't associate, as
you can see in the previous dmesg (wlan1). The capture is was to see
what packets the b43 driver is sending. I was asked to do this by
Johannes Berg.
