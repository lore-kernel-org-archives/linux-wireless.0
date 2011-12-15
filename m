Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50515 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759737Ab1LOXNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 18:13:36 -0500
Message-ID: <1323990813.18292.2.camel@joe2Laptop> (sfid-20111216_001340_208811_8279905A)
Subject: Re: [PATCH wireless-next] ath: Convert ath_dbg(bar, ATH_DBG_<FOO>,
 to ath_dbg(bar, FOO
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2011 15:13:33 -0800
In-Reply-To: <CAB=NE6Vr-5jKZGfpMbv3=nhwC_Lj1ZxJEW+4NuvGfgYp=m-=Gw@mail.gmail.com>
References: <1323989753.1270.19.camel@joe2Laptop>
	 <CAB=NE6V6AszbNBiMOy4ZacwXqJWeWO0DL3cF_A1E2HVGMicbtA@mail.gmail.com>
	 <1323990336.18122.1.camel@joe2Laptop>
	 <CAB=NE6Vr-5jKZGfpMbv3=nhwC_Lj1ZxJEW+4NuvGfgYp=m-=Gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 15:09 -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 15, 2011 at 3:05 PM, Joe Perches <joe@perches.com> wrote:
> > sed/emacs
> > inspection of formats post sed.
> Is it easy to run again at a later time or was it a bitch?

Pretty trivial, but the format mods post coalescing
(missing newlines, missing spaces) were eyeballed.

Unless you've got a _lot_ of unqueued patches for
wireless-next, I doubt the delta will be very high.

