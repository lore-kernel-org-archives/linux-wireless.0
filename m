Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49813 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbZBXI64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 03:58:56 -0500
Date: Tue, 24 Feb 2009 10:58:34 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
Message-ID: <20090224085834.GA10851@jm.kir.nu> (sfid-20090224_095859_101697_BCAA338E)
References: <20090223163626.20939.4879.stgit@tikku> <20090223163738.20939.25890.stgit@tikku> <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com> <87prh9ht22.fsf@litku.valot.fi> <43e72e890902231111g3705c5bh445e3317de5967f3@mail.gmail.com> <87bpst7xxd.fsf@litku.valot.fi> <43e72e890902232046v3c785a01s42e411e47a22288f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890902232046v3c785a01s42e411e47a22288f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 08:46:59PM -0800, Luis R. Rodriguez wrote:

> How does the hardware deal with IEs that may change order? I am not
> sure how common this is but I do wonder.

There are no such IEs; there is an explicit requirement for the order of
IEs in the Beacon frames. Or well, the last slot is for vendor specific
stuff, but anyway, I would agree with Johannes on someone changing the
order of IEs in Beacons to be quite idiotic.

-- 
Jouni Malinen                                            PGP id EFC895FA
