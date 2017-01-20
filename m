Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:43944 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdATOOA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:14:00 -0500
Date: Fri, 20 Jan 2017 15:13:50 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Subject: Re: [PATCH v4 1/3] rt2x00: add copy of clk for soc devices
Message-ID: <20170120141349.GA22861@makrotopia.org> (sfid-20170120_151403_854197_75EA140C)
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
 <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 20, 2017 at 02:28:24PM +0100, Stanislaw Gruszka wrote:
> Since clk_get() is not trivial add copy of clk pointer to rt2x00dev
> for System On Chip devices and initialize it on probe routine.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
