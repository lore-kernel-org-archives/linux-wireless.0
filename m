Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:40931 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbdAMPqx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 10:46:53 -0500
Date: Fri, 13 Jan 2017 16:46:30 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
Message-ID: <20170113154629.GG2332@makrotopia.org> (sfid-20170113_164656_743337_630DDD13)
References: <20170113035020.GA9063@makrotopia.org>
 <87tw93i6e7.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tw93i6e7.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, Jan 13, 2017 at 12:46:56PM +0200, Kalle Valo wrote:
> Daniel Golle <daniel@makrotopia.org> writes:
> > ...
> > Please review and comment, so we can get those patches merged!
> 
> No pull requests, please. Instead send these as patches, easier to
> review and actually also easier for me to merge.

The advantage of pull requests is that author information can be
preserved more easily. Running git format-patch results in most patches
having wrong SMTP sender information due to the assumption that the
patch author is the same person also submitting the patch.
So in practise, this would either require changing the From: (and thus
Author) to myself or having most mails eaten by anti-spam measures due
to non-matching SPF which prohibits my SMTP to send mail on behalf of
the original authors of the patches.

How do you suggest to handle this situation?


Cheers


Daniel
