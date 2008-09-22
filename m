Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:9854 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYIVBNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 21:13:25 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1352746rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2008 18:13:24 -0700 (PDT)
Message-ID: <1197ff4c0809211813o26648b28vb881c42dbc9fcb69@mail.gmail.com> (sfid-20080922_031341_625542_0681ACA7)
Date: Mon, 22 Sep 2008 09:13:24 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: mesh portal functionality support
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Javier Cardona" <javier@cozybit.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1222032877.3023.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222003802.3023.26.camel@johannes.berg>
	 <1222032877.3023.61.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 5:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-21 at 15:30 +0200, Johannes Berg wrote:
>>
>> +                       u8 broadcast[ETH_ALEN] = {0xFF, 0xFF, 0xFF,
>> +                                                 0xFF, 0xFF, 0xFF};
>
> One more thing, heh, this can be static const.
>
> johannes
>

Will be fixed later :)
