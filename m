Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:51743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYF1TIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 15:08:43 -0400
Received: by wf-out-1314.google.com with SMTP id 27so937508wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 12:08:43 -0700 (PDT)
Message-ID: <69e28c910806281208k392a15a6se4e2e4a6f4c05068@mail.gmail.com> (sfid-20080628_210913_432411_A869F87F)
Date: Sat, 28 Jun 2008 21:08:42 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Problem making compat-wireless-2.6
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"George Fong" <george@lateralplains.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890806281157u13daec5en5b5a4d7e5e00a3df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806281953.16371.george@lateralplains.com>
	 <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
	 <20080628151056.GA6110@tuxdriver.com>
	 <43e72e890806281157u13daec5en5b5a4d7e5e00a3df@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 8:57 PM, Luis R. Rodriguez <mcgrof@gmail.com> w=
rote:
> On Sat, Jun 28, 2008 at 8:10 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Sat, Jun 28, 2008 at 01:21:54PM +0200, Stefanik G=E1bor wrote:
>>
>>> Try editing drivers/net/wireless/b43/rfkill.c, and replacing
>>> RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
>>> RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill =
is
>>> not part of the compat package, and no work has been done to match
>>> compat-wireless to older RFKILLs.
>>
>> FWIW, rfkill probably _should_ be in compat-wireless.  Luis?
>
> I haven't had a chance to port rfkill yet down to 2.6.22. If someone
> is interested I'd be glad to accept patches.
>
>  Luis
>

Right now, compat-wireless doesn't work even on 2.6.25, for this
reason. Even an implementation that requires 2.6.25 would be an
improvement from here.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
