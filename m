Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63066 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAPAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 11:00:37 -0400
Received: by mail-ob0-f173.google.com with SMTP id vb8so2690630obc.32
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2014 08:00:34 -0700 (PDT)
Message-ID: <53DBAB90.3040401@lwfinger.net> (sfid-20140801_170041_212618_A853E893)
Date: Fri, 01 Aug 2014 10:00:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rohit Kumar <rkthebest@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Fwd: cross compiling realtek 8188 (RTL8188EU)
References: <CABzetm2Af-_WD29MrejTUQOH9pqDzCGCj8JC9LqyuTp5dyrT9Q@mail.gmail.com> <CABzetm3EgZrvaL370TnCFgDfoeFKqJ-LfhnExSjNwPnW6-HM=Q@mail.gmail.com>
In-Reply-To: <CABzetm3EgZrvaL370TnCFgDfoeFKqJ-LfhnExSjNwPnW6-HM=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2014 12:55 AM, Rohit Kumar wrote:
> Hello,
> 
> i have compiled the driver for USB to wifi dongle which uses realtek
> 8188 chipset for ARM11.
> it works fine but
> 
> iw wlan0 info
> shows "no device found"
> 
> but iwconfig works fine.
> 
> also how can i add nl80211 support for the driver?

When you post about a particular piece of hardware, please use the full name.
There are at least 3 different Realtek chips that have 8188 in their name.
Please do not make us have to assume what you mean.

If you want nl80211 support, you will need to add the necessary structures and
callbacks to the driver. Driver r8723au in the staging tree could serve as
sample code. If you do make these changes, they should be made as patches to the
driver in drivers/staging/rtl8188eu/.

Larry

