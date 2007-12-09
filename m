Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44199 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbXLIXhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 18:37:38 -0500
Date: Mon, 10 Dec 2007 00:31:20 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 2/3] rc80211-pid: introduce PID sharpening factor
Message-ID: <20071210003120.0078db1d@morte> (sfid-20071209_233740_838908_B324D337)
In-Reply-To: <1197239361.7543.17.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209212133.43030d03@morte>
	<1197239361.7543.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 09 Dec 2007 23:29:21 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Note that current rate_control_pid_sample() is only called from
> rate_control_pid_tx_status(), which does an tx_num_xmit++ in advance. So
> the tx_num_xmit branch should actually never be executed (I kept it only
> to guard against any division by zero errors).

Eek? Removing the misleading comment would have been nice... where does
interpolation occur now? I got a bit confused by this.


--
Ciao
Stefano
