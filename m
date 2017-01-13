Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:41270 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdAMQof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 11:44:35 -0500
Date: Fri, 13 Jan 2017 17:17:23 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        lede-dev@lists.infradead.org, openwrt-devel@lists.openwrt.org,
        john@phrozen.org, nbd@nbd.name, roman@advem.lv, evaxige@qq.com,
        c.mignanti@gmail.com, michel.stempin@wanadoo.fr,
        vasilugin@yandex.ru, Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
Message-ID: <20170113161722.GH2332@makrotopia.org> (sfid-20170113_174440_004563_AB0D2B62)
References: <20170113035020.GA9063@makrotopia.org>
 <87tw93i6e7.fsf@purkki.adurom.net>
 <20170113154629.GG2332@makrotopia.org>
 <1484323199.8670.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484323199.8670.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2017 at 04:59:59PM +0100, Johannes Berg wrote:
> 
> > The advantage of pull requests is that author information can be
> > preserved more easily. Running git format-patch results in most
> > patches
> > having wrong SMTP sender information due to the assumption that the
> > patch author is the same person also submitting the patch.
> > So in practise, this would either require changing the From: (and
> > thus
> > Author) to myself or having most mails eaten by anti-spam measures
> > due
> > to non-matching SPF which prohibits my SMTP to send mail on behalf of
> > the original authors of the patches.
> > 
> 
> This is completely untrue. If the first line of the *body* of the email
> is "From: ..." then this is preserved as the author information by git
> am, and doing so is also the default in git format-patch/send-email
> when the author doesn't match the email configuration.

Thanks for the clarification, I'll then submit the patches via
git format-patch.

Cheers

Daniel
