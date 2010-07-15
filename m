Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:33435 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0GOEWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 00:22:16 -0400
Received: by pxi14 with SMTP id 14so241276pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 21:22:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <003201cb23cd$527f3f90$aa01a8c0@satya>
References: <1279152521-10805-1-git-send-email-lrodriguez@atheros.com>
	<003201cb23cd$527f3f90$aa01a8c0@satya>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 14 Jul 2010 21:21:54 -0700
Message-ID: <AANLkTimc0k8SmNnyRpa05luw6nKR-qy0rLBe09TBi4qS@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: Fix AR9003 MPDU delimeter CRC check for middle
	subframes
To: Satya <satya.rao@redpinesignals.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tushit Jain <tushit.jain@atheros.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 8:24 PM, Satya <satya.rao@redpinesignals.com> wrote:
>
> I just wonder if the delimiter length CRC is wrong, where from we
> get the length of the data packet to get to a state where we say
> we have received the data packet with correct CRC ?
>
> I am not sure about this. I appreciate if someone could clarify this.
> Thanks.

Great question  :), Kyungwan, Kyungwan?

PS. This e-mail thread is on a public mailing list.

  Luis
