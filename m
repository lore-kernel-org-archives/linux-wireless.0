Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:21911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZKNS7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 13:59:11 -0500
Received: by fg-out-1718.google.com with SMTP id d23so693886fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 10:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258223973.21252.1.camel@johannes.local>
References: <1258156563.4589.2.camel@localhost.localdomain>
	<43e72e890911131614v1b5ac6f5xa80caab69f400d4e@mail.gmail.com>
	<1258159451.4589.3.camel@localhost.localdomain> <43e72e890911140943t3a70b9a9g3ab9002b4acb92de@mail.gmail.com>
	<1258223973.21252.1.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 14 Nov 2009 19:58:56 +0100
Message-ID: <69e28c910911141058y1d758a00idd69c51ea6ec96c7@mail.gmail.com>
Subject: Re: Unable to buid mac80211 with pid and minstrel
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	=?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 14, 2009 at 7:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-11-14 at 09:43 -0800, Luis R. Rodriguez wrote:
>
>> Anyone recall why PID is pegged to embedded?
>
> The entire selection is since we didn't think it'd matter to anyone to
> have _no_ algorithms (only embedded systems with ath9k and its rc), and
> minstrel was deemed to be a good default for everything else.
>
> johannes
>

But in the current state, minstrel is not simply a default for
non-embedded systems; rather, it's the only choice allowed. It is like
blocking SLAB on non-embedded systems, only allowing SLUB.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
