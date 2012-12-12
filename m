Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hostpark.net ([212.243.197.30]:50799 "EHLO
	mail.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2LLILF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 03:11:05 -0500
Message-ID: <50C83998.4020508@elsoft.ch> (sfid-20121212_091108_754626_9F2DA90E)
Date: Wed, 12 Dec 2012 09:00:24 +0100
From: =?ISO-8859-1?Q?=22David_M=FCller_=28ELSOFT_AG=29=22?=
	<d.mueller@elsoft.ch>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800: refactor RFCSR initialization
References: <20121212053054.GA4356@localhost.localdomain>
In-Reply-To: <20121212053054.GA4356@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Stanislaw Gruszka wrote:
> +static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
> +{
> +	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
> +	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
> +	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
> +	rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
> +	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
> +	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
> +	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> +	rt2800_rfcsr_write(rt2x00dev, 7, 0x50);


Wouldn't a table based initialization be more readable and also shorter?

Dave

