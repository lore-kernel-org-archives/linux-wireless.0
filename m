Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52338 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYLWMuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 07:50:39 -0500
Received: by bwz14 with SMTP id 14so9736554bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 04:50:37 -0800 (PST)
Message-ID: <8e92b4100812230450w4693fb37tb11b852eddc66a6f@mail.gmail.com> (sfid-20081223_135045_247475_C711485F)
Date: Tue, 23 Dec 2008 18:20:37 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1229965970.4406.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081223044424.GC11534@myhost.users.atheros.com>
	 <1229965970.4406.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 10:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-12-22 at 20:44 -0800, Vivek Natarajan wrote:
>> This patch enables mac80211 to send a null frame and also to
>> check for tim in the beacon if power save is enabled.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>
> Looks good to me, to be sure, this is all dependent on !NO_STACK_PS,
> right?

Yes, it all depends on that flag. I will send these RFCs as patches.

Thanks,
Vivek.
