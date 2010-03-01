Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51106 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0CATDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 14:03:03 -0500
Received: by pwj8 with SMTP id 8so1840619pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 11:03:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8AAC55.6080600@gmail.com>
References: <4B8AAC55.6080600@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 11:02:43 -0800
Message-ID: <43e72e891003011102ne9654h2220b36176967613@mail.gmail.com>
Subject: Re: speed not reported for interface
To: Brandon White <bwhite82@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 28, 2010 at 9:48 AM, Brandon White <bwhite82@gmail.com> wrote:
> Hello,
>
> I have compiled and installed the latest compat-wireless and iwconfig
> reports:
>
> bit rate=0 kb/s and network manager shows "speed: unknown".
>
> The card is an Intel 4965agn. Please let me know any other information
> that you may need (logs, output, etc)
>
> Thanks,

iwconfig is 802.11n-stupid. Use iw:

http://wireless.kernel.org/en/users/Documentation/iw

I thought John recently changed cfg80211 to spit out the right bit/s
for 802.11n even for wext. Not sure. Anyway, it would be a good thing
to forget about iwconfig now.

  Luis
