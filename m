Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37023 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbcFJJVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:21:00 -0400
Message-ID: <1465550453.2308.0.camel@sipsolutions.net> (sfid-20160610_112104_431024_738C7858)
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Felix Fietkau <nbd@nbd.name>
Cc: "A. Benz" <ash.benz@bk.ru>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 10 Jun 2016 11:20:53 +0200
In-Reply-To: <CA+BoTQ=xWetiO9GK_staz=M=rAT4_tA5khedqn206mjyRHsmQg@mail.gmail.com> (sfid-20160610_111051_322091_FF8AB05C)
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru>
	 <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com>
	 <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
	 <CA+BoTQ=xWetiO9GK_staz=M=rAT4_tA5khedqn206mjyRHsmQg@mail.gmail.com>
	 (sfid-20160610_111051_322091_FF8AB05C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-10 at 11:10 +0200, Michal Kazior wrote:
> 
> Hmm.. could it be related to ath10k not fulfilling (some) NAPI's
> locking requirements and thus ending up with, e.g. linked-list
> mayhem?
> 

Shoudln't matter since ath10k doesn't actually use rx_napi()?

johannes
