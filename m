Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab2GIJOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:14:18 -0400
Date: Mon, 9 Jul 2012 11:14:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Woody Hung <Woody.Hung@mediatek.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : RT3290 chip support v4
Message-ID: <20120709091408.GD2438@redhat.com> (sfid-20120709_111422_416557_4A64DE74)
References: <1339570876-2367-1-git-send-email-Woody.Hung@mediatek.com>
 <CAGXE3d9_y0M0YaibK4+Kq8Gcf_dHawivwC2wT5iV7+u9bT-C3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGXE3d9_y0M0YaibK4+Kq8Gcf_dHawivwC2wT5iV7+u9bT-C3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 09:45:49AM +0200, Helmut Schaa wrote:
> > +#define RT3290_POWER_BOUND     0x27
> > +#define RT3290_FREQ_OFFSET_BOUND       0x5f
> >  #define RT5390_POWER_BOUND     0x27
> >  #define RT5390_FREQ_OFFSET_BOUND       0x5f
> 
> Any reason why we cannot reuse the existing defines as they seem to be equal?
> Maybe we could just remove the prefix?

Because before that would conflict with some other patch, now we can merge
those two defines.

Stanislaw
