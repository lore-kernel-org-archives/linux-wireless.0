Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0KPVer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:34:47 -0500
Subject: Re: [iwlwifi] Rate Adaptation
From: Johannes Berg <johannes@sipsolutions.net>
To: "An (Jack) Chan" <jackachan@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=PZ8TH2PG7rKz9-nt3S4ZLzvMw_478QrYOpVkm@mail.gmail.com>
References: <AANLkTikb+2PypN+nOGDYbuN1mRGjWCZRuTQ16HsRNo=p@mail.gmail.com>
	 <AANLkTi=PZ8TH2PG7rKz9-nt3S4ZLzvMw_478QrYOpVkm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 13:36:18 -0800
Message-ID: <1289943378.3673.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-16 at 21:12 +0100, An (Jack) Chan wrote:

> Does anyone know where I can find the implementation of rate
> adaptation in iwl5000 driver?

It's in iwl-agn-rs.c

johannes

