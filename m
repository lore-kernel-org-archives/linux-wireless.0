Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:32876 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbJRJcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 05:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <1445122898-5810-3-git-send-email-paulmcquad@gmail.com>
References: <1445122898-5810-1-git-send-email-paulmcquad@gmail.com>
	<1445122898-5810-3-git-send-email-paulmcquad@gmail.com>
Date: Sun, 18 Oct 2015 11:32:50 +0200
Message-ID: <CACna6rxotaUpArMtcBhQ6r5-=VpsoNDLTRZd4PyVB0Epc3atwg@mail.gmail.com> (sfid-20151018_113315_438282_020081DF)
Subject: Re: [PATCH 3/3] net: wireless: b43: statics Don't init to 0
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	David Miller <davem@davemloft.net>,
	Joe Perches <joe@perches.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	mike.looijmans@topic.nl, cengelma@gmx.at, khoroshilov@ispras.ru,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 October 2015 at 01:01, Paul McQuade <paulmcquad@gmail.com> wrote:
> Don't turn statics to 0 or NULL

Same request as Michael's in 2/3. Your "statics Don't init to 0"
message sounds strange, statics *are* initialized to 0 by default (as
you probably know but described it in a unclear way).
