Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39608 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYE1KO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 06:14:58 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K1IgG-0004Xf-P4
	for linux-wireless@vger.kernel.org; Wed, 28 May 2008 10:14:52 +0000
Received: from 62.28.35.120 ([62.28.35.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 10:14:52 +0000
Received: from tolas_feup by 62.28.35.120 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 10:14:52 +0000
To: linux-wireless@vger.kernel.org
From: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Date: Wed, 28 May 2008 10:14:42 +0000 (UTC)
Message-ID: <loom.20080528T100534-804@post.gmane.org> (sfid-20080528_121505_696186_5DE459FD)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>  <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>  <loom.20080527T105701-941@post.gmane.org>  <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com> <1211896423.1746.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see... That's the idea I had, WEP greater than 128-bit as an extra, an attempt
to add more "security" by some manufacturers. If the wireless drivers and
current hardware were made with the standards in mind, then maybe adding support
for more than 128-bit WEP may require more work than it deserves :)
I have a Dlink router and I don't remember ever seeing 256bit WEP or something
like that. When I bought it I didn't know a thing about wireless, but when I
read about WEP and TKIP back then, the choice was clear. Maybe not supporting
these WEP "modes" will keep more people from using it, preferring better
protection instead...

