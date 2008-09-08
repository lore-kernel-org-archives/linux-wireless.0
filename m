Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:29792 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbYIHUsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 16:48:36 -0400
Received: by yx-out-2324.google.com with SMTP id 8so928794yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 13:48:35 -0700 (PDT)
Message-ID: <1ba2fa240809081348n17a3b4c5o4d67e989dfd79030@mail.gmail.com> (sfid-20080908_224840_644464_7C71AE31)
Date: Mon, 8 Sep 2008 23:48:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: HT action frame code
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48C5868B.8060103@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg> <48C5868B.8060103@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 11:09 PM, Jouni Malinen <j@w1.fi> wrote:
> Johannes Berg wrote:
>>
>> When we're an AP, shouldn't we also in some way honour the block-ack
>> action frames? Or will that be done in hostapd, which then sets up
>> block-ack via some unspecified way?
>
> The current design assumes that hostapd takes care of all management frames,
> so eyes, these would need to go to hostapd for processing and then setup
> back to mac80211 through some new command..
>
Enable BA in AP mode is really trivial. It definitely worked in our AP project.
Tomas
