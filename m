Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward16.mail.yandex.net ([95.108.253.141]:50905 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3JGME4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 08:04:56 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"gwingerde@gmail.com" <gwingerde@gmail.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>
In-Reply-To: <20131007082457.GB2418@redhat.com>
References: <39871380943748@web17j.yandex.ru> <20131007082457.GB2418@redhat.com>
Subject: Re: [regression] [bisected] rt2800pci doesn't work after 9483f40d8d01918b399b4e24d0c1111db0afffeb
MIME-Version: 1.0
Message-Id: <85301381147490@web10g.yandex.ru> (sfid-20131007_140508_652487_29187129)
Date: Mon, 07 Oct 2013 16:04:50 +0400
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

07.10.2013, 12:28, "Stanislaw Gruszka" <sgruszka@redhat.com>:

> šOn Sat, Oct 05, 2013 at 07:29:08AM +0400, Kirill Tkhai wrote:
>> ššGIt bisect says the first bad commit is 9483f40d8d01918b399b4e24d0c1111db0afffeb:
>>
>> ššššššššššAuthor: Jakub Kicinski <kubakici@wp.pl>
>> ššššššššššDate: ššTue May 7 00:28:50 2013 +0200
>>
>> ššššššššššššššrt2x00pci: Use PCI MSIs whenever possible
>>
>> ššššššššššššššAll PCIe devices must support MSIs, make use of them.
> šI posted revert of that patch some time ago, it's on the way
> šupstream/stable ...
>

I bought this device one or two weeks ago, so I had not watched linux-wireless.git ;)
This fix was not in linux-next.git when I wrote the message.

If sometimes you need testing the driver on device with IDs like I wrote I'm ready
to help with this.

Kirill
