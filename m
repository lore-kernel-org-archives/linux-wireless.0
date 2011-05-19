Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63609 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621Ab1ESUez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 16:34:55 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 13:34:24 -0700
Date: Thu, 19 May 2011 13:34:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sarah Nadi <snadi@uwaterloo.ca>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: PROBLEM: No config definition for ATHEROS_AR71XX
Message-ID: <20110519203433.GB4884@tux> (sfid-20110519_223458_425925_01633139)
References: <4DD5315A.4050005@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4DD5315A.4050005@uwaterloo.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 19, 2011 at 08:03:54AM -0700, Sarah Nadi wrote:
> #ifdef CONFIG_ATHEROS_AR71XX
> int ath_ahb_init(void);
> void ath_ahb_exit(void);
> #else
> static inline int ath_ahb_init(void) { return 0; };
> static inline void ath_ahb_exit(void) {};
> #endif

This was present in openwrt tree, Gabor has started moving
this stuff upstream, and recently removed the ifdef stuff
anyway IIRC.

  Luis
