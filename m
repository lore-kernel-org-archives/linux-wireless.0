Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:62545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYEOUoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 16:44:08 -0400
Received: by rv-out-0506.google.com with SMTP id l9so700986rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 13:44:07 -0700 (PDT)
Message-ID: <b6c5339f0805151344m2832d8e0s2d2b62338e2f8d5b@mail.gmail.com> (sfid-20080515_224414_151581_8FF4E42E)
Date: Thu, 15 May 2008 16:44:07 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <eb97335b0805150953m5d5fd39bm896b7a108a1909c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
	 <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com>
	 <b6c5339f0805141209p4a8b1b2do1cb2ec1c11de07e8@mail.gmail.com>
	 <eb97335b0805150741g252ba49ckbf1b493a46acf762@mail.gmail.com>
	 <b6c5339f0805150945j8c3847ctd66f88180902a029@mail.gmail.com>
	 <eb97335b0805150953m5d5fd39bm896b7a108a1909c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2008 at 12:53 PM, Zack Weinberg <zackw@panix.com> wrote:
>> Unless anyone
>> else has ideas, I would suggest capturing a trace using mmiotrace and
>> ndiswrapper to see what is going on.  Someone on ath5k-devel list
>> might have a better idea.
>
> I don't know how to do that, can you point me at instructions?

There are some instructions over here, but they are a little out of date:

    http://madwifi.org/wiki/DevDocs/MadwifiTrace

I think believe the info from the nouveau link below is more recent.
It's changed a lot even since the last time I ran it a month or two
ago, so you may have to do a little research.  "Built-in mmiotrace"
seems to be where it's going lately.

    http://nouveau.freedesktop.org/wiki/MmioTrace

First step would be to get your card working under ndiswrapper, I guess.

-- 
Bob Copeland %% www.bobcopeland.com
