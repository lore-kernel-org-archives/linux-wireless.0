Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54289 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbXLJIX0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 03:23:26 -0500
Date: Mon, 10 Dec 2007 09:17:01 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH v2 2/3] rc80211-pid: introduce PID sharpening
 factor
Message-ID: <20071210091701.208c2d2a@morte> (sfid-20071210_082329_660324_8FB6A635)
In-Reply-To: <1197272696.7490.31.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209212133.43030d03@morte>
	<1197239361.7543.17.camel@localhost>
	<20071210003120.0078db1d@morte>
	<1197244416.7543.27.camel@localhost>
	<20071210032811.5cea4909@morte>
	<1197268081.7490.10.camel@localhost>
	<20071210082154.015f6e6a@morte>
	<1197272696.7490.31.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 08:44:56 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> You're totally right. But IMHO it's nicer to be a little defensive here.
> You never know what happens to your code in the future. Just imagine
> somebody coming up with: Hey, let's use a timer-based approach for
> sampling. Ok, that's easy to do, just call sample() every time the timer
> expires. And whoops, there's the division by zero when no packets are
> transmitted...

Ok, you are right, I'll fix this.


-- 
Ciao
Stefano
