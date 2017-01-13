Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:33406 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdAMWRQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 17:17:16 -0500
Date: Fri, 13 Jan 2017 23:17:01 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        lede-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com,
        openwrt-devel@lists.openwrt.org, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [OpenWrt-Devel] [RFC] [PULL REQUEST] rt2x00 patches from
 OpenWrt.org
Message-ID: <20170113221700.GB32160@makrotopia.org> (sfid-20170113_231719_676713_F4FE27B1)
References: <20170113035020.GA9063@makrotopia.org>
 <87tw93i6e7.fsf@purkki.adurom.net>
 <20170113154629.GG2332@makrotopia.org>
 <1484323199.8670.5.camel@sipsolutions.net>
 <20170113161722.GH2332@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170113161722.GH2332@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2017 at 05:17:23PM +0100, Daniel Golle wrote:
> On Fri, Jan 13, 2017 at 04:59:59PM +0100, Johannes Berg wrote:
> > 
> > > The advantage of pull requests is that author information can be
> > > preserved more easily. Running git format-patch results in most
> > > patches
> > > having wrong SMTP sender information due to the assumption that the
> > > patch author is the same person also submitting the patch.
> > > So in practise, this would either require changing the From: (and
> > > thus
> > > Author) to myself or having most mails eaten by anti-spam measures
> > > due
> > > to non-matching SPF which prohibits my SMTP to send mail on behalf of
> > > the original authors of the patches.
> > > 
> > 
> > This is completely untrue. If the first line of the *body* of the email
> > is "From: ..." then this is preserved as the author information by git
> > am, and doing so is also the default in git format-patch/send-email
> > when the author doesn't match the email configuration.
> 
> Thanks for the clarification, I'll then submit the patches via
> git format-patch.

I posted all patches on the mailing list and bundled them up on
patchwork.
https://patchwork.kernel.org/bundle/dangole/rt2x00-from-openwrt/

Cheers


Daniel
