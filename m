Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34498 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab0LLRsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 12:48:18 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PRq1v-0003C8-J4
	for linux-wireless@vger.kernel.org; Sun, 12 Dec 2010 18:48:15 +0100
Received: from 194.48.133.8 ([194.48.133.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 18:48:15 +0100
Received: from messier31 by 194.48.133.8 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 18:48:15 +0100
To: linux-wireless@vger.kernel.org
From: Thomas <messier31@gmx.net>
Subject: Re: carl9170 802.11n-AP
Date: Sun, 12 Dec 2010 18:47:56 +0100
Message-ID: <ie31sg$rqv$1@dough.gmane.org>
References: <loom.20101212T101545-636@post.gmane.org> <loom.20101212T110657-413@post.gmane.org> <AANLkTimiNLZ8EFPEwbKW3UA7FMSxmJOV-B9pWY4h9c34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

thanks for your answer.
I am afraid I am too much of a linux noob to solve this on my own.
Its not the Intel driver that crashes but carl9170. But I am going to test 
this with other wifi cards as well and then post the results here.

Get well soon! (for carl9170 sake :D)

Regards,

Thomas

Christian Lamparter wrote:

> On Sun, Dec 12, 2010 at 11:14 AM, thomas
> <messier31@gmx.net> wrote:
>> I just saw that there could be "aggregation stalls" with "any Intel N
>> Wifi Link".
>> I am using Intel Wifi Link 5100 and the driver frequently restarts under
>> heavy load.
> 
> see Intel's bugzilla, lots of angry posts there:
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214#c19 (etc...)
> 
> I am ill, so you'll have to do the research on iwlwifi vs. carl9170 on
> your own, but it's all there just take a look at the original vendor
> driver(otus)+firmware(ar9170fw).
> 
> Regards,
>    Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


