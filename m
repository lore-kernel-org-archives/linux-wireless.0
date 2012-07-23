Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2GWLYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 07:24:45 -0400
Date: Mon, 23 Jul 2012 13:24:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Matt Chen <machen@suse.com>
Cc: kevin.chou@mediatek.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120723112359.GA2567@redhat.com> (sfid-20120723_132449_450952_C6327FC2)
References: <1342667903-27314-1-git-send-email-machen@suse.com>
 <20120719145430.GA4231@redhat.com>
 <CALx5=V8Sz_CiqQvX-N1hscmpYa7GTO2YfukS8BJc1YChLFmd5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALx5=V8Sz_CiqQvX-N1hscmpYa7GTO2YfukS8BJc1YChLFmd5Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Jul 23, 2012 at 03:01:08PM +0800, Matt Chen wrote:
> >> +
> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x018);
> >> +                     udelay(REGISTER_BUSY_DELAY);
> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x418);
> >> +                     udelay(REGISTER_BUSY_DELAY);
> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x618);
> > We really like to know what those black magic numbers mean.
> I have no idea, Ralink gave it to me for the fixing.

So perhaps patch should be posted by Ralink developer, who can fix that
accordingly?

Also it's clear now that you are not the author of the patch. Would be
good to indicate true author of the patch by adding "From:" and
"Signed-off-by:" lines.

Thanks
Stanislaw
