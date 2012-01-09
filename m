Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:44307 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab2AIXOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 18:14:30 -0500
Received: by qadb15 with SMTP id b15so2578207qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 15:14:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rx_q6J4PU0ucX+ZJqqkzpp24pf3Mz+Od2HPtVg8w-r1pQ@mail.gmail.com>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
 <CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
 <20120109222544.11008.qmail@stuge.se> <CACna6rx_q6J4PU0ucX+ZJqqkzpp24pf3Mz+Od2HPtVg8w-r1pQ@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 10 Jan 2012 00:14:09 +0100
Message-ID: <CA+XFjiqdiAwaZmN9PLQhmvxHNZ1Bgkr-NwHb4nLaP5PWm2eU8w@mail.gmail.com> (sfid-20120110_001434_562220_572092BC)
Subject: Re: BCM43231
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/9 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 9 stycznia 2012 23:25 u¿ytkownik Peter Stuge <peter@stuge.se> napisa³:
>> Rafa³ Mi³ecki wrote:
>>> I've been using "usbmon" to dump traffic.
>>
>> The tool at http://people.redhat.com/zaitcev/linux/usbmon-6.tar.gz
>> and not simply cat on the usbmon files in debugfs I hope.
>>
>> debugfs only shows the first bytes of long transfers, but the API
>> used by the usbmon-6 tool shows complete traffic.
>
> I was just using
> cat /sys/kernel/debug/usb/usbmon/0u
>
> I didn't see info about eating the rest of transfer in
> Documentation/usb/usbmon.txt. Thanks for the tip, I'll give it a
> chance tomorrow.

This information, if true, should go into Documentation/usb/usbmon.txt.
