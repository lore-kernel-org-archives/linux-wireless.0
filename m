Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52244 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1EIIvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:51:00 -0400
Received: by qyk7 with SMTP id 7so776053qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 01:50:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8739kos3cm.wl@dns1.atmark-techno.com>
References: <201104181526.01722.IvDoorn@gmail.com>
	<201104301601.15558.IvDoorn@gmail.com>
	<87d3k1rzuw.wl@dns1.atmark-techno.com>
	<201105022124.10614.IvDoorn@gmail.com>
	<8739kos3cm.wl@dns1.atmark-techno.com>
Date: Mon, 9 May 2011 10:50:58 +0200
Message-ID: <BANLkTin9YVtc++yuqaLG8szZ4PvLy-_ehA@mail.gmail.com> (sfid-20110509_105115_177510_556D12BE)
Subject: Re: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Yasushi SHOJI <yashi@atmark-techno.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	helmut.schaa@googlemail.com, hanada@atmark-techno.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> At Mon, 2 May 2011 21:24:09 +0200,
> Ivo van Doorn wrote:
>>
>> >  - CPU consumption was not an issue (sorry for wrong info. my bad)
>> >  -- but network throughput performance is bad
>> >  - USB controller on the CPU is not fast
>> >  -- max throughput for USB memory read is about 50 Mbps on our test
>> >  -- max client mode transfer rate is about 20 Mbps (at best)
>>
>> Ah ok, as CPU consumption is not the problem, then I better understand the problem.
>> My previous patch missed one fix for a return value. Could you try this one.
>
> it works like a charm!  you can put a tested-by tag on this patch. :-)

Good news. :)
The patch has been sent upstream, it has already been picked up in
wireless-testing.git
and wireless-next-2.6.git a few days ago but hasn't yet by the
compat-wireless package.
So if all goes correct, the compat-wireless package which will be
generated today will
contain the fix.

Ivo
