Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41056 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2FGSeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:34:10 -0400
Received: by obbtb18 with SMTP id tb18so1212714obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 11:34:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120607193027.05389791@milhouse>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<4FD0E3F3.2060900@lwfinger.net>
	<20120607193027.05389791@milhouse>
Date: Thu, 7 Jun 2012 20:34:09 +0200
Message-ID: <CAHsu+b-6WsiHrhQ5crCtmT4MYttDJznOMyGB4NMyUYzXfgAaVQ@mail.gmail.com> (sfid-20120607_203414_059202_941238A0)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 7, 2012 at 7:30 PM, Michael Büsch <m@bues.ch> wrote:
> On Thu, 07 Jun 2012 12:25:07 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> I do not understand what is different about your system than mine.
>
> I think the difference is that he runs opensource firmware, for which the queuenumber
> patching comes into effect. You should be able to reproduce even with standard
> firmware by disabling QOS with the module parameter.

As far as I can tell openfwwf is the only working firmware for this chip.
It's 'special': http://www.gc-linux.org/wiki/Wii:WLAN
