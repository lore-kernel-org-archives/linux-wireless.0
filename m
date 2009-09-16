Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44548 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZIPXyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 19:54:44 -0400
Received: by iwn8 with SMTP id 8so2479570iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 16:54:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <191513177.20090917035628@mail.ru>
References: <191513177.20090917035628@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 16 Sep 2009 16:54:28 -0700
Message-ID: <43e72e890909161654x141f48e4q54f0526bf6c04ea3@mail.gmail.com>
Subject: Re: 2.6.25 kernel & compat-wireless-2009-09-14
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2009 at 5:56 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello all,
>
> After some more digging I think I've found an incompatibility.
>
> device_add in 2.6.25.20 wants some bus_id, but bus_id seems to not
> be assigned anymore, so device_add fails. Therefore, wiphy_register
> fails, and then clearly ieee80211_register_hw fails too.
>
> Any ideas how to properly fix this?

FIgure out what the bus_id is used for first.

  Luis
