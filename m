Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33602 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab0KRRDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:03:06 -0500
Received: by fxm10 with SMTP id 10so116240fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 09:03:04 -0800 (PST)
Message-ID: <4CE55C3B.6020803@lwfinger.net>
Date: Thu, 18 Nov 2010 11:02:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>	 <1288823326-9686-2-git-send-email-zajec5@gmail.com>	 <20101116212321.GF10774@tuxdriver.com> <1290013976.2513.14.camel@maggie>	 <20101118162748.GB2468@tuxdriver.com> <1290098156.12596.2.camel@maggie>	 <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com>	 (sfid-20101118_174421_892253_3B53C8D3) <1290098865.12596.6.camel@maggie>
In-Reply-To: <1290098865.12596.6.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 10:47 AM, Michael Büsch wrote:
> If it would really succeed to initialize the device, this would be a
> regulatory issue, because the sprom contains various power amplifier
> calibration data. I think it should rather fail and be fixed correctly
> instead of incorrectly using rev1 in that case.

I agree that it is better to fail than use incorrect power data.

Would it be useful if the SPROM data were logged when the revision is crap?

John: could you dump and post the data from yours? I would like to see how bad
it is.

Larry
