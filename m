Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53702 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0HaXIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 19:08:14 -0400
Received: by wyb35 with SMTP id 35so8462245wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 16:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283278232.3733.53.camel@jlt3.sipsolutions.net>
References: <1283237477.3733.0.camel@jlt3.sipsolutions.net>
	<1283277436-5922-1-git-send-email-linville@tuxdriver.com>
	<1283278232.3733.53.camel@jlt3.sipsolutions.net>
Date: Tue, 31 Aug 2010 19:08:12 -0400
Message-ID: <AANLkTik=2j37W3-DUsb_JsK1zySec7bqfhORqijq9RAN@mail.gmail.com>
Subject: Re: [PATCH] wireless: register wiphy rfkill w/o holding cfg80211_mutex
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rjw@sisk.pl,
	maciej.rutecki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Works great!  Thanks.

On Tue, Aug 31, 2010 at 2:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-08-31 at 13:57 -0400, John W. Linville wrote:
>> Otherwise lockdep complains...
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=17311
> ...
>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Thanks John.
>
> johannes
>
>
