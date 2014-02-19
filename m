Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45990 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBSBK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 20:10:59 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so11142133lbg.22
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 17:10:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389108901.4645.13.camel@jlt4.sipsolutions.net>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
 <1387486399-4053-3-git-send-email-mcgrof@do-not-panic.com> <1389108901.4645.13.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 17:10:37 -0800
Message-ID: <CAB=NE6VeOM95u_-86yno0Hiz_DvXGz6b9G4tKdUT=PfYposLKA@mail.gmail.com> (sfid-20140219_021102_609055_11CB933D)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 7:35 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>> This allows processing of the last regulatory request when
>> we determine its still pending. This fixes the issue reported
>> by Sander of when cfg80211 is built-in and no further regulatory
>> domain processing can happen. This occurred because if the
>> filesystem was not mounted upon kicking off the udev rule
>> to run CRDA then the last request will always be left
>> unprocessed.
>
> It'd be good to comment on what this actually changes and what happens,
> in addition to discussing the user-visible effect?

Sure.

  Luis
