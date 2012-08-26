Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55074 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HZRhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 13:37:31 -0400
Received: by ghrr11 with SMTP id r11so750296ghr.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 10:37:31 -0700 (PDT)
Message-ID: <503A5ED8.7030701@wybc.com> (sfid-20120826_193812_007932_9EE4D455)
Date: Sun, 26 Aug 2012 13:37:28 -0400
From: Sherwin Soltani <sherwin@wybc.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: AR9462 btcoex doesn't appear to work
References: <50394BE4.3000508@wybc.com> <20537.33465.256314.716102@gargle.gargle.HOWL> <5039B192.3000206@wybc.com> <20120826060550.GA6979@vmraj-lnx.qca.qualcomm.com> <20120826060932.GB6979@vmraj-lnx.qca.qualcomm.com> <5039D4BF.8070602@wybc.com> <20538.6354.852040.883826@gargle.gargle.HOWL>
In-Reply-To: <20538.6354.852040.883826@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2012 08:38 AM, Sujith Manoharan wrote:
> Sherwin Soltani wrote:
>> Yes, that was the output of lspci, I misread, sorry. lsusb -v attached
>> (after I did 'modprobe ath3k').
> There doesn't seem to be a BT device in the usb list ?
>
> Sujith

My stupidity. After fiddling around I figured out it was disabled by a 
hardware switch (Fn-F3), which was why it wasn't showing up. It shows up 
now, and seems to be working. Sorry about that.
