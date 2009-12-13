Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48585 "HELO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751479AbZLMNgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 08:36:31 -0500
MIME-Version: 1.0
In-Reply-To: <1260710042.2442.340.camel@johannes.local>
References: <5a4c581d0912120740j38a20f8eu3f616f3a477d922f@mail.gmail.com>
	 <1260710042.2442.340.camel@johannes.local>
Date: Sun, 13 Dec 2009 14:36:29 +0100
Message-ID: <5a4c581d0912130536r46b13b95pcd1364ee83cd39c0@mail.gmail.com>
Subject: Re: 2.6.32-git5+, CONFIG_WEXT_PRIV and Broadcom's driver for BCM4322
	Wireless chips
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 13, 2009 at 2:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-12-12 at 16:40 +0100, Alessandro Suardi wrote:
>
>> But: what is the best option here to make CONFIG_WEXT_PRIV visible at
>>  kernel build time if only an external module should select it - but selection
>>  is not actually happening at kernel build time ?
>> Could CONFIG_WEXT_PRIV be made a separate user-selectable option ?
>
> Your only option is selecting some other (ancient) driver that selects
> WEXT_PRIV. We will not make that Kconfig symbol visible just because
> Broadcom decided that they want to continue screwing their users :)
>
> IOW -- there's no such option available to you at all. Select
> PCMCIA_RAYCS or whatever.

Thanks - you clipped the part of my message where I explain that my
 "workaround" has been to select IPW2200 :)

I'm aware of the implications of out-of-tree proprietary drivers, I just
 wanted to make sure I wasn't missing a better option than the one
 I resorted to.

Thanks again,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
