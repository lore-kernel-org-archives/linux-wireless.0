Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39101 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0ASSCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 13:02:35 -0500
Received: by pwj9 with SMTP id 9so2555743pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 10:02:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263923968.28066.2.camel@johannes.local>
References: <1263884721-11008-1-git-send-email-tomas.winkler@intel.com>
	<43e72e891001190953r122625d3pf805c318e9662340@mail.gmail.com>
	<1263923722.25138.2.camel@johannes.local> <43e72e891001190957u3ccc12ey955e6d15b33eba13@mail.gmail.com>
	<1263923968.28066.2.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 10:02:15 -0800
Message-ID: <43e72e891001191002q10ee8359wfffa813b3db8a0d2@mail.gmail.com>
Subject: Re: [PATCH 1/1] update rfkill.h from kernel 2.6.33
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 9:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-01-19 at 09:57 -0800, Luis R. Rodriguez wrote:
>> On Tue, Jan 19, 2010 at 9:55 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2010-01-19 at 09:53 -0800, Luis R. Rodriguez wrote:
>> >> On Mon, Jan 18, 2010 at 11:05 PM, Tomas Winkler
>> >> <tomas.winkler@intel.com> wrote:
>> >> > 1. add FM radio type
>> >> > 2. update rfkill_type docs
>> >> >
>> >> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> >>
>> >> Why is this being pushed for 2.6.33 at this point?
>> >
>> > ??? Have you read the patch?
>>
>> So this is updating linux-next to get 2.6.33 rfkill stuff? How did
>> that happen?
>
> You still haven't read it? :)
>
> It's for rfkill userspace.

Jeesh, sorry about that. Monday e-mail trigger happy.

  Luis
