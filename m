Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53755 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZLOFBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 00:01:53 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 21:01:53 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19239.6382.946135.302792@gargle.gargle.HOWL>
Date: Tue, 15 Dec 2009 10:34:46 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] ath9k: Fix bug in assigning sequence number
In-Reply-To: <43e72e890912140658x3a12d554ta904ed63a0d1c75b@mail.gmail.com>
References: <19238.1248.439940.601526@gargle.gargle.HOWL>
	<43e72e890912140658xa88e8feq9589b29448d5d7e4@mail.gmail.com>
	<43e72e890912140658x3a12d554ta904ed63a0d1c75b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Dec 14, 2009 at 6:58 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Mon, Dec 14, 2009 at 1:26 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> >> The internal, driver-specific maintenance of sequence
> >> numbers is applicable only for HT frames.
> >>
> >> Also, remove comments that are not relevant anymore.
> >>
> >> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> >
> > Is this cc: stable?
> 
> Also what bug does this fix, the commit log in no way explains any of this.

The patch just removes redundant maintenance of sequence numbers in the code.

Sujith
