Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50644 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0ATWiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 17:38:12 -0500
Received: by fxm20 with SMTP id 20so702287fxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 14:38:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001191002q10ee8359wfffa813b3db8a0d2@mail.gmail.com>
References: <1263884721-11008-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e891001190953r122625d3pf805c318e9662340@mail.gmail.com>
	 <1263923722.25138.2.camel@johannes.local>
	 <43e72e891001190957u3ccc12ey955e6d15b33eba13@mail.gmail.com>
	 <1263923968.28066.2.camel@johannes.local>
	 <43e72e891001191002q10ee8359wfffa813b3db8a0d2@mail.gmail.com>
Date: Thu, 21 Jan 2010 00:30:09 +0200
Message-ID: <1ba2fa241001201430g6cc4e3b9h9b49e47e81e9e755@mail.gmail.com>
Subject: Re: [PATCH 1/1] update rfkill.h from kernel 2.6.33
From: Tomas Winkler <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 8:02 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jan 19, 2010 at 9:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2010-01-19 at 09:57 -0800, Luis R. Rodriguez wrote:
>>> On Tue, Jan 19, 2010 at 9:55 AM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>> > On Tue, 2010-01-19 at 09:53 -0800, Luis R. Rodriguez wrote:
>>> >> On Mon, Jan 18, 2010 at 11:05 PM, Tomas Winkler
>>> >> <tomas.winkler@intel.com> wrote:
>>> >> > 1. add FM radio type
>>> >> > 2. update rfkill_type docs
>>> >> >
>>> >> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>>> >>
>>> >> Why is this being pushed for 2.6.33 at this point?
>>> >
>>> > ??? Have you read the patch?
>>>
>>> So this is updating linux-next to get 2.6.33 rfkill stuff? How did
>>> that happen?
>>
>> You still haven't read it? :)
>>
>> It's for rfkill userspace.
>
> Jeesh, sorry about that. Monday e-mail trigger happy.

:)

Is there any preferable patch prefix for rfkill  utility? Just to make
mail sorting a bit easier ...

Tomas
