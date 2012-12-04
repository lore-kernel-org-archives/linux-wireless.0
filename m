Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab2LDJ7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 04:59:24 -0500
Date: Tue, 4 Dec 2012 10:59:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: introduce
 IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Message-ID: <20121204095905.GA3021@redhat.com> (sfid-20121204_105928_331851_1CFAEF7B)
References: <20121203115632.GA2490@redhat.com>
 <50BCB3A3.4090708@01019freenet.de>
 <201212031629.16806.chunkeey@googlemail.com>
 <50BD03EF.3010504@01019freenet.de>
 <CAGXE3d-MFLsQr1xdWqk0bVdFj2VR+Bspffazaka3NzvWPusLUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-MFLsQr1xdWqk0bVdFj2VR+Bspffazaka3NzvWPusLUg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 03, 2012 at 09:21:38PM +0100, Helmut Schaa wrote:
> Yep, this makes definitely sense! And since we can copy big parts of
> the carl9170 patch :D this shouldn't be too much work hopefully ...

But still something that will need to go -next rather than -stable, so
let's apply those patches, and remove them in -next when better patch
will come in.

Stanislaw
