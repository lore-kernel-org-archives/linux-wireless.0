Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:40582 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZEZUQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 16:16:35 -0400
Received: by pxi1 with SMTP id 1so3269821pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 13:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 May 2009 13:16:17 -0700
Message-ID: <43e72e890905261316r25f81977h2e3cc857ac73a000@mail.gmail.com>
Subject: Re: 2.6.30-rc7: Reported regressions from 2.6.29
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Janousek <tomi@nomi.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 24, 2009 at 12:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

Should help with reading, we have only 2 left for wireless:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13337
> Subject         : [post 2.6.29 regression] hang during suspend of b44/b43 modules
> Submitter       : Tomas Janousek <tomi@nomi.cz>
> Date            : 2009-05-18 10:59 (7 days old)


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject         : Page allocation failures with b43 and p54usb
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2009-04-29 21:01 (26 days old)
> References      : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>
