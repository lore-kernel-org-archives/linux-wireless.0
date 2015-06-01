Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33477 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbbFAVkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 17:40:06 -0400
Message-ID: <1433194803.3505.19.camel@sipsolutions.net> (sfid-20150601_234010_422017_5F94648E)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS
 mode for frames sent using Nss>1.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 01 Jun 2015 23:40:03 +0200
In-Reply-To: <CABPxzY+eaUB6BY-c71RPxqSThizCM=qzt=K_+4du8zHLrY=_oQ@mail.gmail.com> (sfid-20150601_233352_930422_A8DDD99D)
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1390426022.4334.50.camel@jlt4.sipsolutions.net>
	 <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
	 <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com>
	 <1433191009.3505.18.camel@sipsolutions.net>
	 <CABPxzY+eaUB6BY-c71RPxqSThizCM=qzt=K_+4du8zHLrY=_oQ@mail.gmail.com>
	 (sfid-20150601_233352_930422_A8DDD99D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-02 at 03:03 +0530, Krishna Chaitanya wrote:

> > This patch is *ancient*, before we actually used patchwork properly ...
> Ok, so you want me to send a V2 with the indentation fixed?
> (or) shall i wait for Felix's review before sending V2?

It seems unlikely that anyone would want to review a patch over 15
months later :)

johannes

