Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54446 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2ITNlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 09:41:36 -0400
Received: by bkuw11 with SMTP id w11so226495bku.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 06:41:35 -0700 (PDT)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <eric.dumazet@gmail.com>
To: artem.bityutskiy@linux.intel.com
Cc: Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1348148385.2388.21.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348147322.31352.69.camel@edumazet-glaptop>
	 <1348148385.2388.21.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Sep 2012 15:41:31 +0200
Message-ID: <1348148491.31352.70.camel@edumazet-glaptop> (sfid-20120920_154218_664034_89190957)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 16:39 +0300, Artem Bityutskiy wrote:
> On Thu, 2012-09-20 at 15:22 +0200, Eric Dumazet wrote:

> > OK but you cant do that, or small frames will be dropped.
> > 
> > Anyway its a hack, we should find the buggy layer.
> > 
> > You could use dropwatch (drop_monitor) to check where frame is dropped.
> > 
> > modprobe drop_monitor
> > dropwatch -l kas
> 
> I do not have dropwatch in Tizen, I need to find the sources and compile
> the user-space part. Any hint where to download it?
> 

https://fedorahosted.org/dropwatch/


