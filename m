Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47788 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1GFE3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 00:29:51 -0400
Received: by vws1 with SMTP id 1so4670280vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 21:29:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110630135030.GA15540@jm.kir.nu>
References: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com>
	<20110630135030.GA15540@jm.kir.nu>
Date: Tue, 5 Jul 2011 23:29:50 -0500
Message-ID: <CAJsNL7=-yd5hoJkPUCQOGVjk-5Xw8AMvvCBnsH-b9uF7UY_EbA@mail.gmail.com> (sfid-20110706_062954_915904_88CCBB3E)
Subject: Re: STA Driver/MLME handling for broadcast DEAUTHENTICATE from AP
From: alfred steele <alfred.jaquez@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks.

> Yes, if the broadcast Deauthentication frame has a matching BSSID, the
> station should process it just like it would a unicast one directed to
> it.
Does that essentially mean that the broadcast deauth will translate to
a disconnect event for WPA supplicant. WHat does it show up as on the
WPA control event interface?

Thanks,
Alfred.
