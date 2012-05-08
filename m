Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37464 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2EHJAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 05:00:15 -0400
Received: by obbtb18 with SMTP id tb18so9513620obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 02:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEfJ7vPzHnc5ACHMTnJBFGgDVFpkZ6hJ8QfXtL8L+94gOw@mail.gmail.com>
References: <4FA0405C.8050101@lwfinger.net>
	<CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com>
	<4FA19674.90804@lwfinger.net>
	<1336390235.4325.16.camel@jlt3.sipsolutions.net>
	<CAB3XZEfJ7vPzHnc5ACHMTnJBFGgDVFpkZ6hJ8QfXtL8L+94gOw@mail.gmail.com>
Date: Tue, 8 May 2012 12:00:15 +0300
Message-ID: <CAB3XZEd7H683Gc_2Ytw7-LByOOGy5o_hRsuE3cjLhrONFc=6tg@mail.gmail.com> (sfid-20120508_110021_571634_304C9FAA)
Subject: Re: Wireless problem in 3.4-rc5
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 8, 2012 at 11:32 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Mon, May 7, 2012 at 2:30 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > i'm not sure this is related to the problem you're facing, but the
>>> > commit above seems to have some bug in which a packet might get
>>> > enqueued on invalid queue (0xff) - please try this patch (compile
>>> > tested only):
>>
>> Eliad, can you submit that patch with more details?
>>
> sure, i'll send it soon.
>
i've just figured it that it doesn't seem to have any effect, as the
hw_queue will get overridden anyway in ieee80211_tx (because
IEEE80211_HW_QUEUE_CONTROL is not set), so i'm not sure it's really
needed. do you want me to send it anyway?

Eliad.
