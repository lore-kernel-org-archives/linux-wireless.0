Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40195 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZDPKXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:23:20 -0400
Received: by fxm2 with SMTP id 2so320114fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 03:23:18 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239841291.25334.18.camel@johannes.local>
	<87ocuxf7kv.fsf@litku.valot.fi>
	<1239873166.9737.4.camel@johannes.local>
	<87fxg8apgo.fsf@litku.valot.fi>
	<1239876253.9737.12.camel@johannes.local>
	<878wm0ap2u.fsf@litku.valot.fi>
	<1239877115.9737.16.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 13:23:16 +0300
In-Reply-To: <1239877115.9737.16.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 12\:18\:35 +0200")
Message-ID: <874owoaodn.fsf@litku.valot.fi> (sfid-20090416_122323_947531_634E11EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-16 at 13:08 +0300, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > But ieee80211_sta_work() checks if we're scanning and aborts if we are.
>> 
>> Oh, I missed that one. Yes, you are right.
>
> Maybe we should just set last_beacon = jiffies on scan finished as an
> easy workaround :)

That sounds quite good actually.

I wish I had noticed the check in ieee80211_sta_work() already when I
tried to fix this :)

-- 
Kalle Valo
