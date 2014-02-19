Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36435 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaBSAwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:52:12 -0500
Received: by mail-lb0-f173.google.com with SMTP id s7so11426821lbd.32
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:52:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389108849.4645.12.camel@jlt4.sipsolutions.net>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
 <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com> <1389108849.4645.12.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 16:51:51 -0800
Message-ID: <CAB=NE6WgtqgZTeu-mdduybg_6y+xKXeQEFiOR1gUPOfyBuWJNA@mail.gmail.com> (sfid-20140219_015216_188635_A11654AA)
Subject: Re: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 7:34 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>> This addresses the RCU component of allowing us to reprocess
>> the last regulatory request.
>
> That commit message makes very little sense to me.

Yeah sorry about that, it was a run-on sentence following the subject,
specifically it addressed the issue observed when trying to reprocess
the last regulatory request. I'll send something more coherent.

  Luis
