Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39555 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1FASD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 14:03:57 -0400
Received: by qwk3 with SMTP id 3so29856qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 11:03:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110601184931.499557c6@boulder.homenet>
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
Date: Wed, 1 Jun 2011 20:03:56 +0200
Message-ID: <BANLkTi=Cm1o8HVqugC6JNooP8h+HpJ=aRQ@mail.gmail.com> (sfid-20110601_200400_849677_B3B60A01)
Subject: Re: b43 error under heavy load
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> The one which failed caused the cessation of
> wireless traffic, and was accompanied by the debug log reports of out
> of order TX status earlier referred to, and with only one single report

As I said, I don't really suspect any relation between full TX ring
and out of order problems anymore.

But it won't hurt to ask just in case:
Did you see relation between this single "Stopped TX ring 1" and
massive out of order messages? Did out of order messages starter right
after "Stopped TX ring 1" one?

-- 
Rafał
