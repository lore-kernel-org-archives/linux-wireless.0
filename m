Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59457 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaKXHKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 02:10:43 -0500
Received: by mail-pd0-f177.google.com with SMTP id ft15so9221492pdb.36
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2014 23:10:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416583183.1881.10.camel@sipsolutions.net>
References: <CAGKQeFjfMwFE8d4FVOZY7n3R1=x3naDoxT4-YKUEnA3T7AJcLw@mail.gmail.com>
	<CAGKQeFhjmo4LM9xTCSeuxu8R4VUwUSBiw-q9MaSiwB0eDpKBxg@mail.gmail.com>
	<1416583183.1881.10.camel@sipsolutions.net>
Date: Mon, 24 Nov 2014 12:40:42 +0530
Message-ID: <CAGKQeFg2Jd3EJi1asZgRC2S4WPRxakkcBLz48BKM7FOyWDK3xQ@mail.gmail.com> (sfid-20141124_081046_579136_B625B3BD)
Subject: Re: Fwd: Linux kernel 3.12 PN-KEY Mismatch in wpa.c, packet drop
From: deepak kumar Pradhan <hydipu@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Johannes for your response. Since we were facing this issue,
i looked at the available patches. None solved the issue for us.
I may be missing something, can you please let me know if the solution
for this is already available?
Any inputs much appreciated.

regards

On Fri, Nov 21, 2014 at 8:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-11-21 at 20:42 +0530, deepak kumar Pradhan wrote:
>> Hi,
>>
>> Sorry for interrupting you.
>> The below patch do recovers from pn-key mismatch in kernel 3.12 kernel
>> packet drop issue.
>> I don't know where I need to submit this patch for proper solution.
>
> This is the right place for submitting a proper solution, but I believe
> you've already been told that what you're doing isn't a proper solution
> at all.
>
> johannes
>



-- 
Deepak Kumar Pradhan
