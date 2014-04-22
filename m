Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:64084 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDVDBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 23:01:02 -0400
Received: by mail-la0-f45.google.com with SMTP id hr17so3844636lab.32
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 20:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19510493295.20140417140740@eikelenboom.it>
References: <1397646587-11078-1-git-send-email-arik@wizery.com> <19510493295.20140417140740@eikelenboom.it>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Apr 2014 20:00:40 -0700
Message-ID: <CAB=NE6XYT6V0YnzhcFS_xpT5vhgY65GmYxkrDk6L1hP_G6Hr6g@mail.gmail.com> (sfid-20140422_050106_172822_B331903F)
Subject: Re: [PATCH] cfg80211: avoid freeing last_request while in flight
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>, Colleen T <colleen@cozybit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 17, 2014 at 5:07 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
> Hi Johannes,
>
> Could you put whatever (combination of) patches you see fit into you -next
> tree .. so i can retest what will hopefully go upstream in the next mergewindow.
> I think that will also increase further testcoverage (and if something else
> arise it gives time to fix it before the next mergewindow). It would be nice
> if it would make it this time around ...

Sander, it'll probably be a while before the series you need gets
merged given the history I see on regression tests now on mac8021-nest
but I'll shortly send two respinned patches you can apply on top of
mac80211-next today if you'd like to test.

  Luis
