Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0IOBS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 21:18:26 -0400
Date: Tue, 14 Sep 2010 21:18:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] wl1271: sdio: claim host only when doing IO
Message-ID: <20100915011809.GB2188@tuxdriver.com>
References: <1283822661-16018-1-git-send-email-ohad@wizery.com>
 <20100914203000.GF2484@tuxdriver.com>
 <AANLkTinCyHrKxDYmdbWWXNRQ+zrHtnqLLDKQa-qp3OFV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinCyHrKxDYmdbWWXNRQ+zrHtnqLLDKQa-qp3OFV@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 11:30:30PM +0200, Ohad Ben-Cohen wrote:
> On Tue, Sep 14, 2010 at 10:30 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > drivers/net/wireless/wl12xx/wl1271_sdio.c: In function ‘wl1271_sdio_set_power’:
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:193: warning: ‘return’ with a value, in function returning void
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:195: warning: ‘return’ with a value, in function returning void
> > drivers/net/wireless/wl12xx/wl1271_sdio.c:186: warning: unused variable ‘func’
> 
> Sorry, I wrote the original patch on my branch which already
> propagates the error code from set_power.
> 
> > I'll fix these in a separate patch.
> 
> If you prefer I can submit a new one.

It's already in fixed now.  Feel free to undo it with a later patch
that needs the error code.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
