Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm23-vm6.bullet.mail.ird.yahoo.com ([212.82.109.235]:44973 "EHLO
	nm23-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913Ab2KWBXD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 20:23:03 -0500
Message-ID: <1353564693.32049.YahooMailClassic@web172303.mail.ir2.yahoo.com> (sfid-20121123_022307_743684_1931BEBB)
Date: Thu, 22 Nov 2012 06:11:33 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 471/493] net: remove use of __devexit
To: gregkh@linuxfoundation.org, Bill Pemberton <wfp5p@virginia.edu>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1353349642-3677-471-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 19/11/12, Bill Pemberton <wfp5p@virginia.edu> wrote:

> CONFIG_HOTPLUG is going away as an
> option so __devexit is no
> longer needed.
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> 
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
> 
> Cc: Jes Sorensen <jes@trained-monkey.org>
> 
> Cc: Samuel Ortiz <samuel@sortiz.org>
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> 
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> Cc: "VMware, Inc." <pv-drivers@vmware.com>
> 
> Cc: Francois Romieu <romieu@fr.zoreil.com>
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl> 
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
> Cc: Luciano Coelho <coelho@ti.com> 
> Cc: netdev@vger.kernel.org
> 
> Cc: linux-can@vger.kernel.org
> 
> Cc: linux-hippi@sunsite.dk
> 
> Cc: virtualization@lists.linux-foundation.org
> 
> Cc: linux-wireless@vger.kernel.org
> 
> Cc: ath5k-devel@lists.ath5k.org
> 
> Cc: b43-dev@lists.infradead.org
> 
> Cc: libertas-dev@lists.infradead.org
> 
> Cc: xen-devel@lists.xensource.com
> 
> ---


Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

The rtl818x parts.

