Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infineon.com ([217.10.60.23]:56255 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYIELeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 07:34:10 -0400
From: <Friedrich.Beckmann@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <illth@gmx.de>
Date: Fri, 5 Sep 2008 13:34:07 +0200
Subject: RE: minimum payload size for FEC
Message-ID: <8469FC7DDCBE054D9653D8506E1FF0F001F63D75EC@mucse406.eu.infineon.com> (sfid-20080905_133415_687009_018526BF)
References: <1220541926.17106.46.camel@pcmik05.zmk.uni-kl.de>
In-Reply-To: <1220541926.17106.46.camel@pcmik05.zmk.uni-kl.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: minimum payload size for FEC
>
> So here is my question:
>
> Is there any situation where the payload to the Viterbi FEC
> is less than
> 256 bits (= 32 bytes) ? (ie. a beacon and such stuff?)
>

I guess the ACK packet is shorter than that (14 Bytes), if I
remember correctly. You can have a look in the standard IEEE 802.11.

Regards

Friedrich
