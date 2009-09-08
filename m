Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61539 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZIHS07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:26:59 -0400
Received: by fxm17 with SMTP id 17so2855864fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 11:27:01 -0700 (PDT)
Message-ID: <4AA6A1F3.4070202@lwfinger.net>
Date: Tue, 08 Sep 2009 13:26:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	John Daiker <daikerjohn@gmail.com>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <4AA69961.9010808@gmail.com> <69e28c910909081106p413b70d8u83a48a63943f123e@mail.gmail.com> <200909082015.17943.mb@bu3sch.de>
In-Reply-To: <200909082015.17943.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> This won't help. The DMA engine reports a descriptor error. That means the device
> was unable to fetch the control data via DMA. Most of the time this indicates
> a bug/failure/quirk in the platform DMA implementation.

I can confirm that mine still works on x86_64 with firmware 410.

I have a spare partition that I will use to load an i386 version of
openSUSE 11.2 M6. That comes with a 2.6.31 kernel and it will be easy
to implement compat-wireless.

Larry



