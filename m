Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52759 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaCQWGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 18:06:20 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so5115416wgg.26
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2014 15:06:19 -0700 (PDT)
Message-ID: <532771CF.5050407@gmail.com> (sfid-20140317_230627_731516_6C832366)
Date: Mon, 17 Mar 2014 22:06:07 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: [BUG] Fix Warning BOGUS urb xfer, pipe
 3 != type 1
References: <1394973251-3055-1-git-send-email-tvboxspy@gmail.com> <20140317215008.GB22663@kroah.com>
In-Reply-To: <20140317215008.GB22663@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/03/14 21:50, Greg KH wrote:
> On Sun, Mar 16, 2014 at 12:34:11PM +0000, Malcolm Priestley wrote:
>> Stable kernels will need patches
>> staging: vt6656: s_nsInterruptUsbIoCompleteRead remove usb_fill_bulk_urb
>> staging: vt6656: PIPEnsInterruptRead use usb_fill_int_urb
>>
>> and a backported version of this patch.
>
> So can you send those backported patches to the stable list when this
> patch hits Linus's tree?
Yes will do.


Malcolm
