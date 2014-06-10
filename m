Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46177 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFJJ6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 05:58:05 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so3759495lbd.14
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 02:58:02 -0700 (PDT)
Message-ID: <5396D6A7.2010005@gmail.com> (sfid-20140610_115809_157364_5018DE4D)
Date: Tue, 10 Jun 2014 11:57:59 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: IvDoorn@gmail.com, helmut.schaa@googlemail.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2800usb: scheduling while atomic
References: <5396C150.6030601@gmail.com> <20140610090655.GF1720@redhat.com>
In-Reply-To: <20140610090655.GF1720@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-06-10 11:06, Stanislaw Gruszka wrote:
> On Tue, Jun 10, 2014 at 10:26:56AM +0200, Pontus Fuchs wrote:
>> I have a reproducible sleep in atomic when I set up hostapd with
>> TKIP on a rt2800 based USB dongle. As soon as a client connects I
>> see this. I guess get_tkip_seq may not sleep.
>
> Someone else reported that already, but fails to test provided patch:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2014-January/006538.html
>
> Does attached patch make the problem gone for you?

Yes. Thanks :)

Cheers,

Pontus


