Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43535 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab0KBHe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 03:34:28 -0400
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTiny9BHyk0_g7gfuZtjNYa4LXG0UKOsyoxMm0_pV@mail.gmail.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	 <1288181398-2358-2-git-send-email-eliad@wizery.com>
	 <1288617893.20937.10.camel@chilepepper>
	 <AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
	 <AANLkTin+RQ8zjbQKFcZJjoVcT=GkuMYTYEbt47TFuAC6@mail.gmail.com>
	 <1288647745.21112.76.camel@powerslave>
	 <AANLkTiny9BHyk0_g7gfuZtjNYa4LXG0UKOsyoxMm0_pV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 09:34:25 +0200
Message-ID: <1288683265.28890.0.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-02 at 08:05 +0100, ext Eliad Peller wrote:
> On Mon, Nov 1, 2010 at 11:42 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> >
> > In any case, I'm not sure I really like this idea of a HW recovery test
> > command.  This should really be done automatically by the driver and,
> > with Juuso's implementation plus the watchdog, we shouldn't really need
> > it.
> >
> as i wrote before - it's mainly for testing purposes.
> that's why adding it as a testcmd made sense to me (i guess we do want
> some easy way to trigger and test the recovery sequence).

Okay, so it's for testing the actual recovery sequence... That makes
sense.  I'll apply your patch.

-- 
Cheers,
Luca.

