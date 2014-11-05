Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46189 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKEU73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 15:59:29 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Tun/tap-variant for 802.15.4/6lowpan?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAGnRvuraknR46wWwqaSFiYQ5YtSSMB0S3pcdQeC_8fOAUGQ-UA@mail.gmail.com>
Date: Wed, 5 Nov 2014 12:59:24 -0800
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <70B03722-6311-4CC9-AAF4-AE2077793791@holtmann.org> (sfid-20141105_215932_543879_6F713880)
References: <CAGnRvuraknR46wWwqaSFiYQ5YtSSMB0S3pcdQeC_8fOAUGQ-UA@mail.gmail.com>
To: Henning Rogge <hrogge@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henning,

> I am working with a external radio module controlled over a serial
> port and would like to use the linux 6lowpan implementation to make it
> IP capable.
> 
> Is there something like the tun/tap-driver for 6lowpan that delivers
> the raw frames back to userspace over a socket?

the simple answer is no. You would need to build an interface for this.

As a side note, we have the linux-wpan@vger.kernel.org mailing list that can be used for this kind of discussion.

Regards

Marcel

