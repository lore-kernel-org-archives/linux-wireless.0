Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53748 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZLOFAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 00:00:50 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 21:00:50 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19239.6319.283286.168640@gargle.gargle.HOWL>
Date: Tue, 15 Dec 2009 10:33:43 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] ath9k: Fix bug in assigning sequence number
In-Reply-To: <43e72e890912140658xa88e8feq9589b29448d5d7e4@mail.gmail.com>
References: <19238.1248.439940.601526@gargle.gargle.HOWL>
	<43e72e890912140658xa88e8feq9589b29448d5d7e4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Dec 14, 2009 at 1:26 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > The internal, driver-specific maintenance of sequence
> > numbers is applicable only for HT frames.
> >
> > Also, remove comments that are not relevant anymore.
> >
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> 
> Is this cc: stable?

No, this bug has been in the code forever.

Sujith
