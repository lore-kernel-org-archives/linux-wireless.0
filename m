Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdAMQAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 11:00:10 -0500
Message-ID: <1484323199.8670.5.camel@sipsolutions.net> (sfid-20170113_170012_857224_60D008B8)
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Golle <daniel@makrotopia.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Date: Fri, 13 Jan 2017 16:59:59 +0100
In-Reply-To: <20170113154629.GG2332@makrotopia.org> (sfid-20170113_164656_743337_630DDD13)
References: <20170113035020.GA9063@makrotopia.org>
         <87tw93i6e7.fsf@purkki.adurom.net> <20170113154629.GG2332@makrotopia.org>
         (sfid-20170113_164656_743337_630DDD13)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The advantage of pull requests is that author information can be
> preserved more easily. Running git format-patch results in most
> patches
> having wrong SMTP sender information due to the assumption that the
> patch author is the same person also submitting the patch.
> So in practise, this would either require changing the From: (and
> thus
> Author) to myself or having most mails eaten by anti-spam measures
> due
> to non-matching SPF which prohibits my SMTP to send mail on behalf of
> the original authors of the patches.
> 

This is completely untrue. If the first line of the *body* of the email
is "From: ..." then this is preserved as the author information by git
am, and doing so is also the default in git format-patch/send-email
when the author doesn't match the email configuration.

johannes
