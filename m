Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57749 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0BSSig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:38:36 -0500
Received: by fxm19 with SMTP id 19so411597fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 10:38:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266603853.29775.1.camel@jlt3.sipsolutions.net>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	<1266591292.15178.1.camel@jlt3.sipsolutions.net> <4B7EB31D.2000603@lwfinger.net>
	<1266596602.15178.2.camel@jlt3.sipsolutions.net> <4B7EBF0A.1060907@lwfinger.net>
	<1266598974.3754.0.camel@jlt3.sipsolutions.net> <69e28c911002190906n647d1a25o5f7268c585fa05c8@mail.gmail.com>
	<1266599361.3754.2.camel@jlt3.sipsolutions.net> <69e28c911002191021w1a1d9656oa762724e398da212@mail.gmail.com>
	<1266603853.29775.1.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 19 Feb 2010 19:33:01 +0100
Message-ID: <69e28c911002191033ye37355dm2b091b0c4ae83933@mail.gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 7:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-02-19 at 19:21 +0100, Gábor Stefanik wrote:
>
>> >> Hmm... rev8 SPROM in an N-PHY?
>> >> Or is this a "low-cost" N-PHY with actual N support disabled
>> (similar
>> >> to Ralink RT2070)?
>> >
>> > I have no idea what you mean by "low-cost" N PHY ... this should be
>> a
>> > 2x2 device.
>
>> I thought it was a device that was based on the N-PHY design, but
>> without support for any 802.11n features.
>
> FWIW, aside from the discussion about SPROM formats which Larry
> clarified, there's no such thing.
>
> IMHO a manufacturer would have to be immensely stupid to build an N-PHY
> design based (!) chip that doesn't at least support MCS rates 0 through
> 7, i.e. 1x1 11n operation.

Well, check Atheros and Ralink for an example. Usually, such chips
aren't "built" on purpose, rather, they have 802.11n support disabled
due to having been found defective (but usable in 802.11g mode) during
manufacturing.

>
> johannes
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
