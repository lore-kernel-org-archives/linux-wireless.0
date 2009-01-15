Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:62805 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbZAOSTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 13:19:48 -0500
Received: by yw-out-2324.google.com with SMTP id 9so525626ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 10:19:47 -0800 (PST)
Message-ID: <43e72e890901151019r41cf1b3cv7deeca7a2a283a79@mail.gmail.com> (sfid-20090115_191953_228586_D4D31207)
Date: Thu, 15 Jan 2009 10:19:46 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: tony@linx.net
Subject: Re: wireless-regdb updated 2009-01-15 (was Re: wireless-regdb updated 2009-01-14)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Helmut Schaa" <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <496F7A5E.5070008@linx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090114162250.GC3854@tuxdriver.com>
	 <200901151011.23147.helmut.schaa@gmail.com>
	 <20090115134928.GA3241@tuxdriver.com>
	 <1232031893.5839.0.camel@johannes>
	 <43e72e890901150954t4bc9a390x43a30f287b609173@mail.gmail.com>
	 <43e72e890901151000y4dda530aw96e76f68b72c3fd4@mail.gmail.com>
	 <496F7A5E.5070008@linx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2009 at 10:03 AM, Tony Vroon <tony@linx.net> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Thu, Jan 15, 2009 at 9:54 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> I'll set CRDA to pull this latest file upon building too by
>> default.
>
> I'd be pleased if that wasn't the default for make all. We explicitly
> separate fetching sources and compiling/installing. (And sources are
> hashed to confirm integrity)
> Otherwise I'd have to patch that out of the Makefile each time.

Yeah I won't do it, thanks.

  Luis
