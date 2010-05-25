Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:45981 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0EYToW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 15:44:22 -0400
Message-ID: <4BFC2677.7050509@mandriva.org>
Date: Tue, 25 May 2010 22:35:19 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-25
References: <20100525170401.GE31753@tuxdriver.com> <AANLkTilMYGSprjMnmRHlZPMvk1KLd1Yeqd_l26yyVRT6@mail.gmail.com>
In-Reply-To: <AANLkTilMYGSprjMnmRHlZPMvk1KLd1Yeqd_l26yyVRT6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

25.05.2010 22:23, Sedat Dilek skrev:
> "[1/2] iwlwifi: fix internal scan race" [1] is in this pull request.
> Isn't "[2/2] iwlagn: work around rate scaling reset delay" [2] missing?
> IIRC, both fixes were sent as a double-patch.
>

It's already upstream:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3bce6066263efb5733ee2141ac8b56684fb3b0a7

> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/99439/
> [2] https://patchwork.kernel.org/patch/99438/
>

--
Thomas
