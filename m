Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39869 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaLZEaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2014 23:30:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y4MXL-0004s1-Bm
	for linux-wireless@vger.kernel.org; Fri, 26 Dec 2014 05:30:03 +0100
Received: from cpe-67-11-235-53.satx.res.rr.com ([67.11.235.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 05:30:03 +0100
Received: from chrischavez by cpe-67-11-235-53.satx.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 05:30:03 +0100
To: linux-wireless@vger.kernel.org
From: Christopher Chavez <chrischavez@gmx.us>
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Fri, 26 Dec 2014 04:23:21 +0000 (UTC)
Message-ID: <loom.20141226T052138-41@post.gmane.org> (sfid-20141226_053021_245401_F4558895)
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <549CCAD8.70704@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:
> In any case, file a bug report at bugzilla.kernel.org, mark it as a regression,
> and post the bug number here. If you are able to finish the bisection, that
> would be helpful.

Reported.
https://bugzilla.kernel.org/show_bug.cgi?id=90331

