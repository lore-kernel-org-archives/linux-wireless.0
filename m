Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:46148 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0ASR51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:57:27 -0500
Received: by pxi12 with SMTP id 12so4765302pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 09:57:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263923722.25138.2.camel@johannes.local>
References: <1263884721-11008-1-git-send-email-tomas.winkler@intel.com>
	<43e72e891001190953r122625d3pf805c318e9662340@mail.gmail.com>
	<1263923722.25138.2.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 09:57:07 -0800
Message-ID: <43e72e891001190957u3ccc12ey955e6d15b33eba13@mail.gmail.com>
Subject: Re: [PATCH 1/1] update rfkill.h from kernel 2.6.33
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 9:55 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-01-19 at 09:53 -0800, Luis R. Rodriguez wrote:
>> On Mon, Jan 18, 2010 at 11:05 PM, Tomas Winkler
>> <tomas.winkler@intel.com> wrote:
>> > 1. add FM radio type
>> > 2. update rfkill_type docs
>> >
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>>
>> Why is this being pushed for 2.6.33 at this point?
>
> ??? Have you read the patch?

So this is updating linux-next to get 2.6.33 rfkill stuff? How did that happen?

  Luis
