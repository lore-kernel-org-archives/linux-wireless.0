Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:55468 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZHSTIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:08:37 -0400
Received: by vws2 with SMTP id 2so3926058vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 12:08:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
	 <20090819150138.GB5905@tuxdriver.com> <20090819180235.GA7126@mosca>
	 <20090819183506.GG5905@tuxdriver.com>
	 <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
Date: Wed, 19 Aug 2009 15:08:38 -0400
Message-ID: <b6c5339f0908191208m2aef3305lcb4cadabeb72733f@mail.gmail.com>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 2:50 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:

> Well so to group all of Intel stuff we do need this, at least I can't
> think of a way to do it. If we don't want to group intel stuff then we
> can remove it. Is there a downside to this grouping, for example?

One (admittedly hand-wavy) argument against vendor grouping is that you
don't always know who made the chip.  So you have CompanyA buying CompanyB's
IP, making a product, and then we write a driver for CompanyA's device
called awifi2000.  Meanwhile CompanyB sells it to CompanyC too so their
"C Wifi Plus" product happens to work with the awifi2000 driver.  Now you
have to reorg the menus to put it under CompanyB.

I imagine this is a lot less likely with wireless, if you know enough to
write a driver, you usually know who made it.  But ISTR it happened a lot
with v4l stuff since there are more commodity parts on those cards.

-- 
Bob Copeland %% www.bobcopeland.com
