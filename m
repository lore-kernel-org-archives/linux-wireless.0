Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64751 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbZFVJm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 05:42:27 -0400
Received: by bwz9 with SMTP id 9so2984764bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 02:42:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: Plan of attack for enhancements for scan while associated
Date: Mon, 22 Jun 2009 11:42:27 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com
References: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com> <200905182107.52613.helmut.schaa@gmail.com>
In-Reply-To: <200905182107.52613.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906221142.28202.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 18. Mai 2009 schrieb Helmut Schaa:
> Am Montag, 18. Mai 2009 schrieb Luis R. Rodriguez:
> > Helmut, Senthil has indicated interest in working on this, Johannes
> > had pointed out you might have some initial work on this already? Can
> > you post your patch, it might help?
> 
> Sure, see below. However, the patch was against mac80211 in February or
> so and due to the recent changes in the scan code it won't apply anymore :)

Senthil, did you already start to work on that? I've rebased the last
version of my patch to current wireless testing and it seems to work quite
well already. However, it still only uses a static time schedule for
switching back to the operating channel.

Thanks,
Helmut
