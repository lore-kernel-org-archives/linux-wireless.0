Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36551 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab3HNQzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 12:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1V9eLf-0001d8-9C
	for linux-wireless@vger.kernel.org; Wed, 14 Aug 2013 18:55:03 +0200
Received: from 195.37.61.178 ([195.37.61.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 18:55:03 +0200
Received: from moony by 195.37.61.178 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 18:55:03 +0200
To: linux-wireless@vger.kernel.org
From: moony <moony@mindsnack.net>
Subject: Re: carl9170: Problems setting up Virtual Interface
Date: Wed, 14 Aug 2013 09:32:57 +0000 (UTC)
Message-ID: <loom.20130814T112720-982@post.gmane.org> (sfid-20130814_185510_035617_33111E5C)
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> <201107042202.27366.chunkeey@googlemail.com> <CAMJnVwm4Xp87pF7PHLP7vVqF-LYzsgeso7ZPzPwOC_39mwP_Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex <alex9434@...> writes:

> 
> Great! I now get an additional interface:
> wlan1-wlan0 Link encap:Ethernet  HWaddr <deleted>
>           BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


Hi Alex,

did you get this to work? I'm using the same driver and procedure, but when
I try to bring up the second interface (with ifup wifi1), I get the error
device or resource busy... The first always comes up.
I don't know if vif is enabled by default on the kernelmodule. I tried to
compile it by myself (there is an option for the number of vif, and the
default is 1), but stuck on errors or missing dependencies, yet.


Best regards,
moony



