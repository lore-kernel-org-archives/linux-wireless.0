Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1KKGNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 01:13:20 -0500
Received: by bke11 with SMTP id 11so2975573bke.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2011 22:13:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVN9wR9mbRVWUA_Poa8ng+9RzHXj6PDfpLfN0djWeYAs9g@mail.gmail.com>
References: <CAG6hwVN9wR9mbRVWUA_Poa8ng+9RzHXj6PDfpLfN0djWeYAs9g@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 11 Nov 2011 08:13:03 +0200
Message-ID: <CA+XVXffySzSsRTduhX9UAWDv=oDt9eSEQe+Oj5RebQ9JZBAgaA@mail.gmail.com> (sfid-20111111_071324_142235_3BEE5585)
Subject: Re: regression in "mac80211: support adding IV-room in the skb for
 CCMP keys"
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 11, 2011 at 07:01, Thomas Pedersen <thomas@cozybit.com> wrote:
> Hello,
>
> Any kernel debugging tips involving stack corruption? :)
>
> When testing a secure mesh topology in qemu using mac80211_hwsim with
> master-2011-11-09 I get a hard lockup, but no OOPS. gdb was able to
> show:
>

Did you try applying this
http://www.spinics.net/lists/linux-wireless/msg79976.html ?

Arik
