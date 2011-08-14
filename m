Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:35104 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753730Ab1HNVT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 17:19:58 -0400
Date: Sun, 14 Aug 2011 22:19:58 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110814221958.6e7a4264@boulder.homenet> (sfid-20110814_232003_955035_2AD9761D)
In-Reply-To: <CACna6ry4LxUAo-s2ViKHH8V1n5Nsc9-Oora3Dazz67jftfX9oA@mail.gmail.com>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
	<20110601130842.077da1c3@boulder.homenet>
	<BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
	<20110601160101.75e30b3d@boulder.homenet>
	<BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
	<20110601184931.499557c6@boulder.homenet>
	<CACna6rxH8_9pc+vZizLyAkNCLK7-CmK6GZP-E2FKUfwR9uD8Xg@mail.gmail.com>
	<CACna6rybejfyg+rNg9ozimHnfGh742EVsjxKZbYKvspFrQS_9w@mail.gmail.com>
	<20110814214626.4413d7cf@boulder.homenet>
	<CACna6ry4LxUAo-s2ViKHH8V1n5Nsc9-Oora3Dazz67jftfX9oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 14 Aug 2011 22:54:20 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> I didn't expect improvement, I tried to make it worse :P I though our
> problems may be coming from not-fast-enough reading RX ring. So you
> just made that ring even smaller to allow faster/easier errors.
> 
> What do you mean by different errors? The only one I can see is
> "b43-phy0 ERROR: PHY transmission error". Do you mean that or
> something else? Did you post all the log you wanted to? Maybe missed
> beginning?

That's it.

On your question "what do you mean by different errors", I mean the
reported errors are different. Without that patch the reported error
is:

b43-phy0 debug: TX-status contains invalid cookie: 0x0DCE
b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 76
b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 78
... and so on.

Chris


