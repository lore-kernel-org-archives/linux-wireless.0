Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53437 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaFLFon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 01:44:43 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so811228obc.15
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 22:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140611230513.GC913@drone.musicnaut.iki.fi>
References: <20140611230513.GC913@drone.musicnaut.iki.fi>
Date: Thu, 12 Jun 2014 07:44:42 +0200
Message-ID: <CACna6rwaxzyY+vqQa+vJETA_g+8zLmwWQb9uYhFOvTy57A15rw@mail.gmail.com> (sfid-20140612_074459_845202_AEF2F304)
Subject: Re: Linux 3.15: WLAN regression on WRL54GL/B43?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2014 01:05, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> While testing the final 3.15, I noticed that "iwlist wlan0 scanning"
> cannot find anything on my WRT54GL router anymore:

I believe it's BCM5352E SoC wth G-PHY rev 7 and radio 0x2050 rev 2. Is
that correct? Provide us a boot log.
