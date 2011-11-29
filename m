Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1K2IdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 03:33:03 -0500
Subject: Re: [PATCH] cfg80211: Fix changing regulatory from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Timo Lindhorst <tlnd@online.de>, linux-wireless@vger.kernel.org
In-Reply-To: <CAB=NE6Xrm3dGTLLrpeKdODKJN3X-fiss6BEeyYAyn2E5TQuJ6g@mail.gmail.com> (sfid-20111128_201500_595293_EAA27F85)
References: <201111230330.11103.tlnd@online.de>
	 <CAB=NE6U6ru-xns8M+YUccqxw0FwE-sWtZnFkPUud3jHdAcDxsw@mail.gmail.com>
	 <20111123143456.GB2502@tuxdriver.com> <20111123144258.GC2502@tuxdriver.com>
	 <CAB=NE6WtBH+jpi3AVAdn2ZTZFPYMx6y73bneTEquZaGbuUJizQ@mail.gmail.com>
	 <20111128184506.GC2681@tuxdriver.com>
	 <CAB=NE6Xrm3dGTLLrpeKdODKJN3X-fiss6BEeyYAyn2E5TQuJ6g@mail.gmail.com>
	 (sfid-20111128_201500_595293_EAA27F85)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:32:56 +0100
Message-ID: <1322555576.4110.10.camel@jlt3.sipsolutions.net> (sfid-20111129_093308_092190_EA7AA3E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 14:14 -0500, Luis R. Rodriguez wrote:

> John, I'll will send a respin after I dissect what Tomas mentioned. I
> have one other patch added to my series also that Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> sent to me that I will be rolling into my
> series. If we are pressed my recommendation is to revert Johannes'
> patch for now, but if you do, please let me know so I can amend my
> patches to address that bit.

I really don't want to revert that since it fixes a NULL pointer
dereference that you can probably trigger fairly easily from userspace
with not much more than well-timed unplug and lots of disk activity.

Why can't you just work on the fix first and then do all those
improvement patches?

johannes

