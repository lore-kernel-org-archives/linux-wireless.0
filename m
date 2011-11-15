Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34148 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1KOGin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111115063309.GB30827@elgon.mountain>
References: <20111115063309.GB30827@elgon.mountain>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 15 Nov 2011 08:38:26 +0200
Message-ID: <CA+XVXfcegKfEqkyMFeWa7gW_bi+GJvUmNvOkpY5ryrAAsSM5pw@mail.gmail.com> (sfid-20111115_073848_269009_065FA794)
Subject: Re: [patch] mac80211: use kfree_skb() instead of kfree()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2011 at 08:33, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> sk_buff structs should be freed using kfree_skb().
>
> This was introduced recently in 029458212 "mac80211: Save probe
> response data for bss".
>

Thanks for this one. I'm getting careless lately.. :)

Arik
