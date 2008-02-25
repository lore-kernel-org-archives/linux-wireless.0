Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52975 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbYBYLUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 06:20:22 -0500
Date: Mon, 25 Feb 2008 12:16:49 +0100
From: Sebastian Siewior <netdev@ml.breakpoint.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jeff Garzik <jgarzik@pobox.com>,
	Masakazu Mokuno <mokuno@sm.sony.co.jp>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [PS3] gelic wireless driver needs MAC80211 support
Message-ID: <20080225111649.GA24352@Chamillionaire.breakpoint.cc> (sfid-20080225_112028_384596_B45DAE42)
References: <20080223193517.GA6704@Chamillionaire.breakpoint.cc> <47C0815F.7020100@pobox.com> <1203934436.13162.64.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1203934436.13162.64.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg | 2008-02-25 11:13:56 [+0100]:

>That seems completely wrong since it's a full-mac "chip" (implemented in
>the HV or so maybe). What exactly does it need from mac80211?
Nothing, please drop. I've sent another patch which enables WEXT what is
the correct thing to do. Sorry for the noise.

>johannes

Sebastian
