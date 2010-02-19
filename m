Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:3623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0BSSWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:22:12 -0500
Received: by fg-out-1718.google.com with SMTP id e21so70081fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 10:22:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266599361.3754.2.camel@jlt3.sipsolutions.net>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	<1266591292.15178.1.camel@jlt3.sipsolutions.net> <4B7EB31D.2000603@lwfinger.net>
	<1266596602.15178.2.camel@jlt3.sipsolutions.net> <4B7EBF0A.1060907@lwfinger.net>
	<1266598974.3754.0.camel@jlt3.sipsolutions.net> <69e28c911002190906n647d1a25o5f7268c585fa05c8@mail.gmail.com>
	<1266599361.3754.2.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 19 Feb 2010 19:21:50 +0100
Message-ID: <69e28c911002191021w1a1d9656oa762724e398da212@mail.gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 6:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-02-19 at 18:06 +0100, Gábor Stefanik wrote:
>
>> > [    5.909764] ssb: SPROM revision 8 detected.
>>
>> Hmm... rev8 SPROM in an N-PHY?
>> Or is this a "low-cost" N-PHY with actual N support disabled (similar
>> to Ralink RT2070)?
>
> I have no idea what you mean by "low-cost" N PHY ... this should be a
> 2x2 device.
>
> johannes
>

I thought it was a device that was based on the N-PHY design, but
without support for any 802.11n features. But if rev8 is really a
superset or rev4 (though I seem to remember that it only has space for
a single TX/RX chain), then it can easily be a real 802.11n device.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
