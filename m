Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:1537 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbZJPO4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 10:56:19 -0400
Received: by gv-out-0910.google.com with SMTP id r4so280333gve.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 07:54:32 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
Date: Fri, 16 Oct 2009 16:54:29 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>, Greg KH <greg@kroah.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
References: <1255575825.10636.17.camel@laptop> <87zl7rbyl2.fsf@nokia.com> <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
In-Reply-To: <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910161654.29933.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 October 2009 16:11:22 Javier Martinez Canillas wrote:
> At least I could make it compile when the API changes and work on bugs
> reported until you are confident that p54spi driver is good enough and
> there is no need anymore for stlc45xx.

p54spi IS stlc45xx, but with a different name.

> The only thing I dont have it is the hardware but I think I could get one N800.
N810 has a extra keyboard... So it might be the better choice for
developers.

Regards,
	Chr
