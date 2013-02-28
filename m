Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55948 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3B1Sxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 13:53:34 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so8129343wid.17
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 10:53:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512F5709.60907@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
	<20130228114724.GB16369@localhost>
	<512F5709.60907@openwrt.org>
Date: Thu, 28 Feb 2013 10:53:32 -0800
Message-ID: <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com> (sfid-20130228_195338_135324_98142330)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2013 05:09, Felix Fietkau <nbd@openwrt.org> wrote:

>> The same could be said of PID...
> I agree, we should remove that one as well.

One of the advantages of having multiple RC modules - even if they're
not longer optimal - is to keep the API honest. :-)

I still keep onoe/amrr working in FreeBSD's ath(4) driver, primarily
to make sure that I don't change the API without thinking too much
about what other rate control modules do, but also to provide a
simpler example of how the API works.

Personally, I'd like to see more examples of rate control modules in
LInux/FreeBSD, especially ones that start demanding more 802.11 state
(ie, air-time QoS.)



Adrian
