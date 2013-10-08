Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:16818 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3JHBxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 21:53:17 -0400
Message-ID: <52536572.4080308@huawei.com> (sfid-20131008_040150_577261_F6FAD747)
Date: Tue, 8 Oct 2013 09:52:50 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] doc: fix some typos in documentations
References: <523921BD.3030205@huawei.com> <1380623046.14430.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380623046.14430.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013/10/1 18:24, Johannes Berg wrote:

> On Wed, 2013-09-18 at 11:45 +0800, Xishi Qiu wrote:
>>  
>>  to ensure the driver cannot be built-in when rfkill is modular. The !RFKILL
>> -case allows the driver to be built when rfkill is not configured, which which
>> +case allows the driver to be built when rfkill is not configured, which
>>  case all rfkill API can still be used but will be provided by static inlines
>>  which compile to almost nothing.
> 
> It looks like this was intended to say "in which" instead of the "which
> which" you remove, rather than just "which".
> 
> johannes
> 

Yes, "in which" seems to be better.

Thanks,
Xishi Qiu

