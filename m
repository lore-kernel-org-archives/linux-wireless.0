Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49643 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYLXWKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 17:10:39 -0500
Message-ID: <20081224171050.uk6j9x861c8g0o0w-cebfxv@webmail.spamcop.net> (sfid-20081224_231044_823060_28F62F4D)
Date: Wed, 24 Dec 2008 17:10:50 -0500
From: Pavel Roskin <proski@gnu.org>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: p54: ad-hoc mode doesn't work
References: <200812230132.21839.rossi.f@inwind.it>
	<200812241828.49679.rossi.f@inwind.it>
	<43e72e890812240940oa599bdds7db3682bfbf95a49@mail.gmail.com>
	<200812242203.22987.rossi.f@inwind.it>
In-Reply-To: <200812242203.22987.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Fabio Rossi <rossi.f@inwind.it>:

> According to my opinion the error message posted in the original message of
> this thread might be misleading for the user: the network card doesn't enter
> in ad-hoc mode because the country for the CRDA is not set while the error
> says that the ad-hoc mode is not supported. What do you think about?

Perhaps we need a separate error code "not permitted by regulations".   
Or we need to reuse one of the existing error codes for that.

-- 
Regards,
Pavel Roskin
