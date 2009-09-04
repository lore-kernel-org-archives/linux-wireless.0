Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53630 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbZIDDPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 23:15:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 20:15:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19104.35102.897450.112606@gargle.gargle.HOWL>
Date: Fri, 4 Sep 2009 08:57:26 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix channelFlags for 2GHZ
In-Reply-To: <43e72e890909031128k4ce1f7b5i5c42ebaa73498c70@mail.gmail.com>
References: <19103.25725.707217.596352@gargle.gargle.HOWL>
	<1251991187.6521.22.camel@mj>
	<43e72e890909031128k4ce1f7b5i5c42ebaa73498c70@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> I should mention ath9k_update_ichannel() was the last thing I intended
> on porting for the new regulatory changes we did on ath9k, when we
> ditched the old regulatory code, but I left it as it did involve quite
> a lot more changes in the code. When I reviewed this it seemed we
> could just rely on the hw->conf.channel->band for many things but in
> some cases we needed some defines for hw.
> 
> So -- I'd personally welcome this change as a better alternative needs
> better planning, and more testing.

Agreed.

Sujith
