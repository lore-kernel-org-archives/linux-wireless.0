Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35204 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYHOGcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 02:32:54 -0400
Date: Fri, 15 Aug 2008 09:32:06 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: scan result IEs in one block
Message-ID: <20080815063206.GD7998@jm.kir.nu> (sfid-20080815_083308_650982_4EA296BC)
References: <20080814174709.GA7998@jm.kir.nu> <20080814181335.GB7998@jm.kir.nu> <43e72e890808141136o489821bej884372b8da9d34ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890808141136o489821bej884372b8da9d34ac@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2008 at 11:36:16AM -0700, Luis R. Rodriguez wrote:
> On Thu, Aug 14, 2008 at 11:13 AM, Jouni Malinen <j@w1.fi> wrote:
> 
> > +       if (bss->ies == NULL || bss->ies_len < elems->total_len) {
> > +               kfree(bss->ies);
> > +               bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);
> 
> Typo here on check for NULL ?

Where? That looks correct to me.

-- 
Jouni Malinen                                            PGP id EFC895FA
