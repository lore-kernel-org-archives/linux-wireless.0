Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44250 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2AIW21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 17:28:27 -0500
Received: by wgbdr10 with SMTP id dr10so2335347wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 14:28:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120109222544.11008.qmail@stuge.se>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
	<CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
	<20120109222544.11008.qmail@stuge.se>
Date: Mon, 9 Jan 2012 23:28:24 +0100
Message-ID: <CACna6rx_q6J4PU0ucX+ZJqqkzpp24pf3Mz+Od2HPtVg8w-r1pQ@mail.gmail.com> (sfid-20120109_232831_358221_50494A78)
Subject: Re: BCM43231
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 stycznia 2012 23:25 użytkownik Peter Stuge <peter@stuge.se> napisał:
> Rafał Miłecki wrote:
>> I've been using "usbmon" to dump traffic.
>
> The tool at http://people.redhat.com/zaitcev/linux/usbmon-6.tar.gz
> and not simply cat on the usbmon files in debugfs I hope.
>
> debugfs only shows the first bytes of long transfers, but the API
> used by the usbmon-6 tool shows complete traffic.

I was just using
cat /sys/kernel/debug/usb/usbmon/0u

I didn't see info about eating the rest of transfer in
Documentation/usb/usbmon.txt. Thanks for the tip, I'll give it a
chance tomorrow.

-- 
Rafał
