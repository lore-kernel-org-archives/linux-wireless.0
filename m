Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm10.bullet.mail.ird.yahoo.com ([77.238.189.39]:24163 "EHLO
	nm10.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab2KVVRg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 16:17:36 -0500
Message-ID: <1353564279.48819.YahooMailClassic@web172305.mail.ir2.yahoo.com> (sfid-20121122_221750_005916_17354123)
Date: Thu, 22 Nov 2012 06:04:39 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 085/493] net/wireless: remove use of __devexit_p
To: gregkh@linuxfoundation.org, Bill Pemberton <wfp5p@virginia.edu>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1353349642-3677-85-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 19/11/12, Bill Pemberton <wfp5p@virginia.edu> wrote:

> CONFIG_HOTPLUG is going away as an
> option so __devexit_p is no longer
> needed.
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> 
> Cc: Jiri Slaby <jirislaby@gmail.com>
> 
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> 
> Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> 
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> 
> Cc: Stefano Brivio <stefano.brivio@polimi.it>
> 
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> 
> Cc: Dan Williams <dcbw@redhat.com>
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> 
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> Cc: Herton Ronaldo Krzesinski <herton@canonical.com>
> 
> Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Cc: Luciano Coelho <coelho@ti.com> 
> Cc: linux-wireless@vger.kernel.org
> 
> Cc: netdev@vger.kernel.org
> 
> Cc: ath5k-devel@lists.ath5k.org
> 
> Cc: b43-dev@lists.infradead.org
> 
> Cc: brcm80211-dev-list@broadcom.com
> 
> Cc: libertas-dev@lists.infradead.org
> 
> Cc: users@rt2x00.serialmonkey.com
> 
> ---

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

The rtl818x parts.

