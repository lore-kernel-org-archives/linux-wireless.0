Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17159 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab0DUCIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 22:08:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 19:08:41 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19406.24076.583237.267376@gargle.gargle.HOWL>
Date: Wed, 21 Apr 2010 07:38:12 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Wiktor Zajas <w.zajas@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: add the 0cf3:1006 TL-WN422G v2 device ID now
In-Reply-To: <20100420154543.GA6472@tuxdriver.com>
References: <43e72e891003281632x17f6d1d9i82640d96baa84096@mail.gmail.com>
	<c13c21871003281831u74976d85lb3d4ece2d59c1f86@mail.gmail.com>
	<43e72e891003281929hfff3821p65a9c42f15d9f6db@mail.gmail.com>
	<c13c21871003281948y40edee0bi36c185b9dfaf4036@mail.gmail.com>
	<43e72e891003282006l266141ehb78a2f4d46db76d6@mail.gmail.com>
	<c13c21871003282118s80d7c8era5585af4a3377bc3@mail.gmail.com>
	<c13c21871003282131x1ebaaee8h74f737c797b71b84@mail.gmail.com>
	<19376.15678.641255.41127@gargle.gargle.HOWL>
	<20100329214009.804ec23f.wzajas@gmail.com>
	<20100329222008.GA2852@tux>
	<20100420154543.GA6472@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Any feedback on this?

This has already been merged.

commit e92119ca88691ac2239916d31c3dcecd10867521
Author: Sujith <Sujith.Manoharan@atheros.com>
Date:   Thu Apr 1 10:28:24 2010 +0530

    ath9k_htc: Add TL-WN422G v2 product ID

    Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Sujith
