Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47506 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZKEClj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 21:41:39 -0500
Message-ID: <4AF23B67.7030507@lwfinger.net>
Date: Wed, 04 Nov 2009 20:41:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] usb: Check results of dma_map_single
References: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net> <200911042049.02761.chunkeey@googlemail.com>
In-Reply-To: <200911042049.02761.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 01:49 PM, Christian Lamparter wrote:
> On Wednesday 04 November 2009 06:48:51 Larry Finger wrote:
>> At http://marc.info/?l=linux-wireless&m=125695331205062&w=2, a problem
>> with DMA buffer processing was corrected for the libertas driver. Because
>> routine usb_fill_bulk_urb() does not check that DMA is possible when
>            ^^^
> hmm, usb_fill_bulk_urb? No, that should be usb_submit_urb :)

Thanks. The actual routine modified is map_urb_for_dma.

Larry

