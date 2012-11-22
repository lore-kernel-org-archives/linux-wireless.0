Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ird.yahoo.com ([77.238.189.203]:22129 "EHLO
	nm8-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227Ab2KVVZn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 16:25:43 -0500
Message-ID: <1353564820.51519.YahooMailClassic@web172303.mail.ir2.yahoo.com> (sfid-20121122_222550_007795_D69DA8A5)
Date: Thu, 22 Nov 2012 06:13:40 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 196/493] net/wireless: remove use of __devinit
To: gregkh@linuxfoundation.org, Bill Pemberton <wfp5p@virginia.edu>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1353349642-3677-196-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 19/11/12, Bill Pemberton <wfp5p@virginia.edu> wrote:

> From: Bill Pemberton <wfp5p@virginia.edu>
> Subject: [PATCH 196/493] net/wireless: remove use of __devinit
> To: gregkh@linuxfoundation.org
> Cc: "John W. Linville" <linville@tuxdriver.com>, "Jiri Slaby" <jirislaby@gmail.com>, "Nick Kossifidis" <mickflemm@gmail.com>, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>, "Simon Kelley" <simon@thekelleys.org.uk>, "Stefano Brivio" <stefano.brivio@polimi.it>, "Stanislav Yakovlev" <stas.yakovlev@gmail.com>, "Dan Williams" <dcbw@redhat.com>, "Christian Lamparter" <chunkeey@googlemail.com>, "Herton Ronaldo Krzesinski" <herton@canonical.com>, "Hin-Tak Leung" <htl10@users.sourceforge.net>, "Larry Finger" <Larry.Finger@lwfinger.net>, "Chaoming Li" <chaoming_li@realsil.com.cn>, "Luciano Coelho" <coelho@ti.com>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ath5k-devel@lists.ath5k.org, b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com, libertas-dev@lists.infradead.org
> Date: Monday, 19 November, 2012, 18:22
> CONFIG_HOTPLUG is going away as an
> option so __devinit is no longer
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
> Cc: Herton Ronaldo Krzesinski <herton@canonical.com>
> 
> Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
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
> ---

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

The rtl818x parts.

