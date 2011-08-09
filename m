Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51779 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1HIJBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:01:50 -0400
Received: by gya6 with SMTP id 6so1752264gya.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:01:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Aug 2011 11:01:49 +0200
Message-ID: <CAGXE3d_PAFX3p7UAeq1CvCnCTCsFgCuGFRLWj-=xgcAJbgKc3g@mail.gmail.com> (sfid-20110809_110153_368245_63C01FE2)
Subject: minstrel_ht and legacy rates?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

minstrel_ht only ever uses MCS rates, however it seems (at least with
rt2x00 devices) that
sometimes legacy rates (1Mbps) can still be used while MCS 0 is
already unusable. For
example when a client is very far away from the AP.

Hence, I'd like to extend minstrel_ht to also sample legacy rates. Any
objections/ideas/hints
from your side?

Thanks,
Helmut
