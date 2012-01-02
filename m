Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:37257 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751410Ab2ABMUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 07:20:24 -0500
Message-ID: <20120102122018.30057.qmail@stuge.se> (sfid-20120102_132027_890835_71D737A9)
Date: Mon, 2 Jan 2012 13:20:18 +0100
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/3] bcma: SPROM: add macro for easier extraction
References: <1325490085-3806-1-git-send-email-zajec5@gmail.com> <1325490085-3806-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1325490085-3806-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> +#define SPEX(_field, _offset, _mask, _shift)	\
> +	bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))

Maybe this should take at least bus as parameter too?


//Peter
