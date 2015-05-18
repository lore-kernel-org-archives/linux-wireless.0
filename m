Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36813 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbERJ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:29:16 -0400
Received: by wizk4 with SMTP id k4so71122786wiz.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 02:29:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431941058.2719.1.camel@sipsolutions.net>
References: <chaitanya.mgit@gmail.com> <1431939609-7261-1-git-send-email-chaitanya.mgit@gmail.com>
 <1431939927.2719.0.camel@sipsolutions.net> <CABPxzYJ-3ctYOdek4RGkt95EKU7Z7qO5qB=8Pb=v+1QN0MCy5A@mail.gmail.com>
 <1431941058.2719.1.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 18 May 2015 14:58:54 +0530
Message-ID: <CABPxzYJD7mHT3dL8DoCLHh5hC5uy4OzjAo0CzrESdg7AkV88HA@mail.gmail.com> (sfid-20150518_112919_578784_09B39DED)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by
 race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2015 at 2:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-05-18 at 14:49 +0530, Krishna Chaitanya wrote:
>
>> My sendmail shows status as bounced so i was trying with different
>> options. I did not realize that it has already made it to the list.
>
> It looks like it didn't actually make it to the list *today*, but I
> believe there were versions that did.
Yes, my git send-email still shows it as bounced due to some wrong
from address.

> I got 4 of them today though ...
Sorry.

> You can always check
> https://patchwork.kernel.org/project/linux-wireless/list/

Thanks, will use that.
