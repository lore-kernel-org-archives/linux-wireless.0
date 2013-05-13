Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:63205 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3EMRUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 13:20:50 -0400
Received: by mail-we0-f177.google.com with SMTP id q58so6548466wes.22
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 10:20:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368465499.8300.33.camel@jlt4.sipsolutions.net>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
 <1368233453-10581-2-git-send-email-ashok@cozybit.com> <1368438160.8300.11.camel@jlt4.sipsolutions.net>
 <CACcxo+odk2L-pymHqof+geeEmKcC4xikebra9jcNZoHOF0by4A@mail.gmail.com> <1368465499.8300.33.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Mon, 13 May 2013 10:20:27 -0700
Message-ID: <CACcxo+qxpDvgGKZX2=2U349h+F8L7vb+qo5WzNCz-bfCjfsq1g@mail.gmail.com> (sfid-20130513_192053_789071_10169673)
Subject: Re: [PATCH 2/3] cfg80211: Allow ieee80211g mandatory rate sets in
 2.4GHz band
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 13, 2013 at 10:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-05-13 at 10:13 -0700, Ashok Nagarajan wrote:
>> On Mon, May 13, 2013 at 2:42 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2013-05-10 at 17:50 -0700, Ashok Nagarajan wrote:
>> >> This patch assumes 11g support
>> >> implies a 11g operation and returns the appropriate mandatory rates.
>> >
>> > Which is a problem, because it means that by default we'll create IBSS
>> > networks that are not compatible with 11b devices.
>>
>> Okay make sense. I would drop just this patch and send rest.
>
> If you just want the others as is I can do that, no need to resend. Let
> me know.
>
Yes, the rest would be as it is now. That would work.

Thanks,
Ashok
> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
