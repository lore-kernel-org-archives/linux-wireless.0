Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41874 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZEQIrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 04:47:21 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M5c1d-0006G3-4N
	for linux-wireless@vger.kernel.org; Sun, 17 May 2009 08:47:17 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 08:47:17 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 08:47:17 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: rt73usb Access point status
Date: Sun, 17 May 2009 09:47:04 +0100
Message-ID: <wfzldcm7zr.fsf@calligramme.charmers>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com> <20090512215817.bd1c6895.cjsthompson@gmail.com> <wf4ovlo25e.fsf@calligramme.charmers> <200905161132.21437.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@gmail.com> writes:

> On Saturday 16 May 2009, Jon Fairbairn wrote:
>> does it work as an AP in Windows?
>> If so, how does it get round the bug in the driver?
>
> Simply by indicating that every single frame passed to the driver has
> been send out succesfully and thus completely ignoring the real status.

Ugh. But Microsoft make the de-facto standards after all :-(
-- for a view that's illuminating, if depressing and
annoying to those of us who think there's a point to
compatibility, watch the talk Butler Lampson gave for Roger
Needham's 50+5 presentation
<http://research.microsoft.com/en-us/um/cambridge/events/needhambook/videos/1032/head.wmv>
(list of talks is at
<http://research.microsoft.com/en-us/um/cambridge/events/needhambook/videos/default.htm>)

> I am awaiting a patch from Alexandre which will add that same behavior
> to rt2x00.

That would be great, thanks!

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


