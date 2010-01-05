Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57896 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0AEKcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:32:06 -0500
Received: by bwz27 with SMTP id 27so9804224bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 02:32:01 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
Subject: Re: [RFC PATCH v5 0/7] mac80211 client U-APSD support
References: <20091231133626.29899.95683.stgit@tikku>
	<1262685061.21956.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 12:31:57 +0200
In-Reply-To: <1262685061.21956.2.camel@johannes.local> (Johannes Berg's message of "Tue\, 05 Jan 2010 10\:51\:01 +0100")
Message-ID: <87r5q4vo4i.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-12-31 at 15:37 +0200, Kalle Valo wrote:
>> Hello,
>> 
>> here is my proposal how to add U-APSD client support to mac80211. I
>> also included example driver implementation for wl1251.
>> 
>> Please comment. Also I would like to get comments how U-APSD needs to
>> be implemented in different hardware.
>
> Looks ok to me (very few comments inline)

Thanks. I'll send v6 later and hopefully John can take that one. We
can improve the u-apsd implementation later on as needed.

> but I haven't researched Intel hardware yet.

I haven't looked either, but I'm hoping that the mac80211 current
implementation is enough also for Intel hardware.

-- 
Kalle Valo
