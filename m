Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52507 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2EHIcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 04:32:51 -0400
Received: by obbtb18 with SMTP id tb18so9485334obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 01:32:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336390235.4325.16.camel@jlt3.sipsolutions.net>
References: <4FA0405C.8050101@lwfinger.net>
	<CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com>
	<4FA19674.90804@lwfinger.net>
	<1336390235.4325.16.camel@jlt3.sipsolutions.net>
Date: Tue, 8 May 2012 11:32:50 +0300
Message-ID: <CAB3XZEfJ7vPzHnc5ACHMTnJBFGgDVFpkZ6hJ8QfXtL8L+94gOw@mail.gmail.com> (sfid-20120508_103300_404679_7C9399AC)
Subject: Re: Wireless problem in 3.4-rc5
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 7, 2012 at 2:30 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-05-02 at 15:17 -0500, Larry Finger wrote:
>> >>
>> >> On my main laptop, this patch causes no problems. On a 3rd box, a BCM4312
>> >> (b43) is OK, but an RTL8187L (rtl8187) also fails in the same manner.
>
> Do you get the warning in iface.c:162 as well? It seems this would cause
> such problems.
>
>> > i'm not sure this is related to the problem you're facing, but the
>> > commit above seems to have some bug in which a packet might get
>> > enqueued on invalid queue (0xff) - please try this patch (compile
>> > tested only):
>
> Eliad, can you submit that patch with more details?
>
sure, i'll send it soon.

Eliad.
