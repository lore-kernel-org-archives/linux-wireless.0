Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:33926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbZHUOmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:42:07 -0400
Received: by fg-out-1718.google.com with SMTP id e21so198345fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 07:42:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250865255.4600.6.camel@johannes.local>
References: <4A8EAFA6.9010608@gmail.com> <1250865255.4600.6.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 16:41:44 +0200
Message-ID: <69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
Subject: Re: Plans for an online meeting regarding Radiotap
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Farina <sidhayn@gmail.com>,
	Mike Kershaw <dragorn@kismetwireless.net>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <"damien bergamini"@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>,
	Dave Young <hidave.darkstar@gmail.com>,
	radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/21 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2009-08-21 at 16:31 +0200, Gábor Stefanik wrote:
>
>> Hope to see you on Freenode at the set date. Again, if the time is a
>> problem, respond, and I will try to find a better time.
>
> I don't think there's any need to have an IRC meeting. We've hashed out
> the way forward multiple times on the radiotap list. What is missing now
> isn't a consensus of how do things, but proposals and implementations.

My intention with the meeting is to form an actual proposal that all
implementors can agree on. We can produce proposals, and even new
standardized fields to no avail, as some implementors (especially
OpenBSD) appear to be stuck with implementations that collide with the
standard. These implementors need to be "awakened" and entered into
the discussions before anything can be done.

>
> Your own proposal had technical flaws (and in my opinion tried to do too
> much at a time) that you haven't addressed -- doing that would be much
> more productive than any such meeting.

What technical flaws are you trying to point out exactly? (The TX
flags field? My point is that it's worthless to "standardize" TX flags
by extending it and moving to "Defined fields" if noone is willing to
implement it.)

>
> johannes
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
