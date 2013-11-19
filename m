Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44442 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3KSTQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 14:16:05 -0500
Received: by mail-bk0-f46.google.com with SMTP id u15so1864791bkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 11:16:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABGE7ds77Ea9YeGBLCCYYDfTFEm0MqjRA03aF=vpv9Y+=Z47oA@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
 <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
 <CAG6hwVOOvKfZcv-J70EMeHM3pmx-ieeAF2-6UtbrmoN3xC=SLw@mail.gmail.com>
 <CABGE7dsTzYESpxfO8WL9JP1BR1QdrTNv5+EszuZm225R2pA=Zw@mail.gmail.com> <CABGE7ds77Ea9YeGBLCCYYDfTFEm0MqjRA03aF=vpv9Y+=Z47oA@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 19 Nov 2013 11:15:43 -0800
Message-ID: <CAG6hwVNqLQB+8ViDyB-XhVx=TzbgZmX-DY6gDaevUoMfETWTVw@mail.gmail.com> (sfid-20131119_201609_110009_3D0EBCDB)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 19, 2013 at 3:39 AM, Gustavo Azambuja
<gazambuja+hostapd@gmail.com> wrote:
> Thank,
> you know where i can find one list of devices (usb dongle) with more
> ram, or without this limit (I need provide Internet at less to 30
> stations)?

No. But a "real" AP would be cheaper and much more perfomant anyway.
Something like the TP-LINK WR841n can be had for about $20.

Nothing stopping you from setting HTC_MAX_STA to 30 and seeing what
happens either!

-- 
Thomas
