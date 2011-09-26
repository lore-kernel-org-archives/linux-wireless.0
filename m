Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64147 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1IZVIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110923061435.GA4387@elgon.mountain>
References: <20110923061435.GA4387@elgon.mountain>
Date: Mon, 26 Sep 2011 18:08:40 -0300
Message-ID: <CAK3JMAbFVcGbRZEPZh1LF+ZuFx8FnbktG91_4kY=Na90OfmT2Q@mail.gmail.com> (sfid-20110926_230845_847404_54BAC508)
Subject: Re: [patch] NFC: use after free on error
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/23 Dan Carpenter <dan.carpenter@oracle.com>:
> We returned a freed variable on some error paths when the intent was
> to return a NULL.  Part of the reason this was missed was that the
> code was confusing because it had too many gotos so I removed them
> and simplified the flow a bit.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
