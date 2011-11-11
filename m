Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1KKSlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 13:41:40 -0500
Received: by wwe5 with SMTP id 5so1735004wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2011 10:41:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffySzSsRTduhX9UAWDv=oDt9eSEQe+Oj5RebQ9JZBAgaA@mail.gmail.com>
References: <CAG6hwVN9wR9mbRVWUA_Poa8ng+9RzHXj6PDfpLfN0djWeYAs9g@mail.gmail.com>
 <CA+XVXffySzSsRTduhX9UAWDv=oDt9eSEQe+Oj5RebQ9JZBAgaA@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 11 Nov 2011 10:41:19 -0800
Message-ID: <CAG6hwVOE8+EDWw+3+s=R+9eO7B+Y=9D8nVAE1gAmksu9hhVkHg@mail.gmail.com> (sfid-20111111_194143_561732_79B0352E)
Subject: Re: regression in "mac80211: support adding IV-room in the skb for
 CCMP keys"
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 10, 2011 at 10:13 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Fri, Nov 11, 2011 at 07:01, Thomas Pedersen <thomas@cozybit.com> wrote:
>> Hello,
>>
>> Any kernel debugging tips involving stack corruption? :)
>>
>> When testing a secure mesh topology in qemu using mac80211_hwsim with
>> master-2011-11-09 I get a hard lockup, but no OOPS. gdb was able to
>> show:
>>
>
> Did you try applying this
> http://www.spinics.net/lists/linux-wireless/msg79976.html ?

That fixed it, thanks!

Thomas
