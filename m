Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35160 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbbLPJOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 04:14:17 -0500
Received: by mail-qk0-f171.google.com with SMTP id u65so35123387qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 01:14:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450182788.3356.14.camel@sipsolutions.net>
References: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com>
	<1450181385.3356.6.camel@sipsolutions.net>
	<CABAco3CgkoCYdHZV6nBfV+CUpD379XR69EiznXvu42p5UC96gw@mail.gmail.com>
	<1450182788.3356.14.camel@sipsolutions.net>
Date: Wed, 16 Dec 2015 10:14:16 +0100
Message-ID: <CABAco3CT3B1bvcXYRxtO2g3ipxw9aJR0YEJWPZhpfkog73t1rQ@mail.gmail.com> (sfid-20151216_101423_510028_33C5CCAB)
Subject: Re: [PATCH] nl80211: Potential memory leaks in reg.c
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm just surprised that none of the tools we (and others) typically run
> found these, and thought perhaps you had a better tool than we do...
> I guess it's called "brain" and we just don't use it right ;-)

Hahaha, I doubt that is the case. :)
