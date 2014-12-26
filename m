Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35191 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaLZOfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 09:35:37 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so14445849wgg.38
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 06:35:35 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Christopher Chavez <chrischavez@gmx.us>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Fri, 26 Dec 2014 15:35:33 +0100
Message-ID: <2868661.A1AiatZ287@debian64> (sfid-20141226_153558_057856_C9E42E3B)
In-Reply-To: <loom.20141226T052138-41@post.gmane.org>
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <549CCAD8.70704@lwfinger.net> <loom.20141226T052138-41@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, December 26, 2014 04:23:21 AM Christopher Chavez wrote:
> Larry Finger <Larry.Finger@...> writes:
> > In any case, file a bug report at bugzilla.kernel.org, mark it as a regression,
> > and post the bug number here. If you are able to finish the bisection, that
> > would be helpful.
> 
> Reported.
> https://bugzilla.kernel.org/show_bug.cgi?id=90331

According to what Larry wrote, this bug should disappear, if
the hw crypto offloading is disabled. 

Christopher, can you please load the p54common kernel module 
with the module parameter "nohwcrypt=1" and report back?

Regards,

Christian

