Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49992 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3KTTp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 14:45:28 -0500
Received: by mail-bk0-f42.google.com with SMTP id w11so648bkz.29
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 11:45:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABGE7dvky+trLL5=hPv13OHhRm9vdbU33Ndyv_oHAjG3+x24+A@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
 <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
 <CAG6hwVOOvKfZcv-J70EMeHM3pmx-ieeAF2-6UtbrmoN3xC=SLw@mail.gmail.com>
 <CABGE7dsTzYESpxfO8WL9JP1BR1QdrTNv5+EszuZm225R2pA=Zw@mail.gmail.com>
 <CABGE7ds77Ea9YeGBLCCYYDfTFEm0MqjRA03aF=vpv9Y+=Z47oA@mail.gmail.com>
 <CAG6hwVNqLQB+8ViDyB-XhVx=TzbgZmX-DY6gDaevUoMfETWTVw@mail.gmail.com> <CABGE7dvky+trLL5=hPv13OHhRm9vdbU33Ndyv_oHAjG3+x24+A@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 20 Nov 2013 11:45:07 -0800
Message-ID: <CAG6hwVN8qJQ1kYhf9LGcebbh2+9aDfS6fE9KMxGVC-WN1bq=pw@mail.gmail.com> (sfid-20131120_204559_090843_86630EAE)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 7:22 AM, Gustavo Azambuja
<gazambuja+hostapd@gmail.com> wrote:
> Thanks Thomas, but is not an option using a "real" AP... I realy need
> to make my own (I need access to MAC address of connected devices and
> use the monitor mode at the same time).

The device I mentioned earlier is fully supported by openwrt, which
gives you a standard linux environment on your router.

-- 
Thomas
