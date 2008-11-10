Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:51245 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYKJIs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 03:48:28 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2365628rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 00:48:27 -0800 (PST)
Message-ID: <31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com> (sfid-20081110_094833_040421_3D55E953)
Date: Mon, 10 Nov 2008 10:48:25 +0200
From: "David Shwatrz" <dshwatrz@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Where is allow-ap-vlan-modes.patch ?
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <200811091604.43705.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com>
	 <200811091604.43705.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  Thanks. I got the testing git tree; it is indeed there (though in a
bit different form; the method in  net/mac80211/cfg.c is called
nl80211_type_check() and not nl80211_type_to_mac80211_type() as in the
patch from
 allow-ap-vlan-modes.patch (2008-06-12). But it allows master mode for AP.

In this occasion may I ask - what is the wireless-testing git tree?
is it based on wireless-next-2.6 or on wireless-2.6 tree?

Regards,
DS



On Sun, Nov 9, 2008 at 5:04 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Sunday 09 November 2008, David Shwatrz wrote:
>> Hello,
>>
>> I have a question:
>> Why was the allow-ap-vlan-modes.patch removed from
>> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/?
>>
>> I see that it was there until recently (to be accurate,
>> 30.10.08 was the last time it was there).
>>
>> I do not see that it was applied; I have the latest git tree of
>> wireless-2.6 and wireless-next-2.6
>
> It is currently present in the wireless-testing git tree.
>
> Ivo
>
