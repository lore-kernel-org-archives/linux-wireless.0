Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:44409 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944Ab2EGPTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:19:13 -0400
Date: Mon, 7 May 2012 18:18:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: hostap@lists.shmoo.com,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
Message-ID: <20120507151858.GA20891@w1.fi> (sfid-20120507_171916_578787_C82A42B7)
References: <4FA75983.9040003@01019freenet.de>
 <201205070702.q4772uem002960@mail.maya.org>
 <20120507135917.GB19222@w1.fi>
 <4FA7D932.1020803@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA7D932.1020803@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2012 at 04:16:18PM +0200, Andreas Hartmann wrote:
> Jouni Malinen wrote:
> > I don't think that hostapd would verify driver capabilities for 802.11w
> > at the moment, so it does not know that it should have rejected the
> > configuration here.. Same for wpa_supplicant and station mode, I'd
> > guess.
> 
> Wouldn't it be better, if it would stop processing completely? I was
> surprised to have a half working connection :-).

Sure, it would be good to verify driver capabilities before even
starting the BSS as AP or trying to associate with 802.11w as station.

-- 
Jouni Malinen                                            PGP id EFC895FA
