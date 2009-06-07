Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:33369 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZFGRGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:06:20 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1715360ywb.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 10:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 7 Jun 2009 10:05:58 -0700
Message-ID: <43e72e890906071005y77d8b28bkabb79be359634a9b@mail.gmail.com>
Subject: Re: 2.6.30-rc8-git4: Reported regressions from 2.6.29
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 7, 2009 at 2:47 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:

Here are just the wireless ones, there are 3:

> Unresolved regressions

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject         : rt2x00: slow wifi with correct basic rate bitmap
> Submitter       : Alejandro Riveira <ariveira@gmail.com>
> Date            : 2009-05-22 13:32 (17 days old)

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13337
> Subject         : [post 2.6.29 regression] hang during suspend of b44/b43 modules
> Submitter       : Tomas Janousek <tomi@nomi.cz>
> Date            : 2009-05-18 10:59 (21 days old)

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject         : Page allocation failures with b43 and p54usb
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Date            : 2009-04-29 21:01 (40 days old)
> References      : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>

  Luis
