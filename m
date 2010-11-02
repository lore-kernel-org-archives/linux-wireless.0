Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58998 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab0KBHFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 03:05:44 -0400
Received: by yxk8 with SMTP id 8so3455727yxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 00:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288647745.21112.76.camel@powerslave>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	<1288181398-2358-2-git-send-email-eliad@wizery.com>
	<1288617893.20937.10.camel@chilepepper>
	<AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
	<AANLkTin+RQ8zjbQKFcZJjoVcT=GkuMYTYEbt47TFuAC6@mail.gmail.com>
	<1288647745.21112.76.camel@powerslave>
Date: Tue, 2 Nov 2010 09:05:43 +0200
Message-ID: <AANLkTiny9BHyk0_g7gfuZtjNYa4LXG0UKOsyoxMm0_pV@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: =?ISO-8859-1?Q?ext_G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 11:42 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
>
> In any case, I'm not sure I really like this idea of a HW recovery test
> command.  This should really be done automatically by the driver and,
> with Juuso's implementation plus the watchdog, we shouldn't really need
> it.
>
as i wrote before - it's mainly for testing purposes.
that's why adding it as a testcmd made sense to me (i guess we do want
some easy way to trigger and test the recovery sequence).

Eliad.
