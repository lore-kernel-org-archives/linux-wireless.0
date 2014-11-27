Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36917 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK0GJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 01:09:54 -0500
Received: by mail-ie0-f178.google.com with SMTP id tp5so4036291ieb.9
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 22:09:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHNKnsRhPW2YGSTvmD-_hPci7V0hqCGyUHy4CfFr5QQtsF=FGw@mail.gmail.com>
References: <2109154365.18865892.1416932147808.JavaMail.root@wmich.edu>
	<1013439490.18867944.1416932462547.JavaMail.root@wmich.edu>
	<CAHNKnsRhPW2YGSTvmD-_hPci7V0hqCGyUHy4CfFr5QQtsF=FGw@mail.gmail.com>
Date: Thu, 27 Nov 2014 07:09:54 +0100
Message-ID: <CACna6rzU8=YBnHj7GjytCs7071qYF9f3A6A7-1aWnC_v27F6Gg@mail.gmail.com> (sfid-20141127_070958_396049_202C3546)
Subject: Re: Setting WLAN RF Sensitivity value
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Mohammad Ali Ma Abu Shattal <mohammad.a.shattal@wmich.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Corporation <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 November 2014 at 00:12, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> Manufacturer of my device is Broadcom. It seems that either the hardware or the driver doesn't support setting and getting sensitivity. I need to know if there exists a device and/or device driver that support this feature. details of my current hardware and device driver are posted in the askubuntu question:
>> http://askubuntu.com/questions/553286/wlan-sensitivity-setting-is-not-supported
>> kindly send me your recommendation for such device or device driver.

There isn't any open source and any mac802111 based driver with
support for LCN40-PHY which is what sits in the BCM43142.

You must be using wl.ko closed driver with very limited cfg80211 API.
That makes things ever worse for you :(

-- 
Rafał
