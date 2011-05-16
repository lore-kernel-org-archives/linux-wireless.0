Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33729 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1EPLG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 07:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimkgtQL1A2A3iAP-UYK2KdDvPmY3Q@mail.gmail.com>
References: <BANLkTimkgtQL1A2A3iAP-UYK2KdDvPmY3Q@mail.gmail.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Mon, 16 May 2011 13:06:06 +0200
Message-ID: <BANLkTinb3kaK7_b=47AL+Mb6Zmt9twEM9g@mail.gmail.com> (sfid-20110516_130636_781890_6C47AB23)
Subject: Re: several packets in a single buffer in Rx
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>, guy.cohen@intel.com
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/16 Emmanuel Grumbach <egrumbach@gmail.com>:
> I would like to be able to deliver the same page several times to the
> stack without having the stack consume it before the last time I
> deliver it.
> Of course I would like to avoid cloning it.

Just do get_page() on the page having another packet in it before
passing skb up.

Best Regards,
Micha³ Miros³aw
