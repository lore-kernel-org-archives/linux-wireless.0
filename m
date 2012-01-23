Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2AWS3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 13:29:09 -0500
Received: by iacb35 with SMTP id b35so4077197iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 10:29:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdo2zBRvyhv39jm98n146w_ppNmi-OR+VBTNj+ReuOyhg@mail.gmail.com>
References: <1327338154-3806-1-git-send-email-eliad@wizery.com>
 <CAB=NE6V26e6caZwCyO2chiZ_7iGVkoD_jtKsxfCLSHumrOp=Wg@mail.gmail.com> <CAB3XZEdo2zBRvyhv39jm98n146w_ppNmi-OR+VBTNj+ReuOyhg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 23 Jan 2012 10:28:48 -0800
Message-ID: <CAB=NE6VgovpKT8gG9Z9AUihOMk7KXLMENBjuQCBAmowMd3TUtQ@mail.gmail.com> (sfid-20120123_192914_524452_A2EA1715)
Subject: Re: [PATCH] compat-wireless: fix wl12xx driver-select
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 10:09 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Mon, Jan 23, 2012 at 7:23 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>> On Mon, Jan 23, 2012 at 9:02 AM, Eliad Peller <eliad@wizery.com> wrote:
>>> wl12xx is a possible choice for both group drivers and
>>> singular modules (making it impossible to build only
>>> the wl12xx module). change the group name to "ti" instead.
>>>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>> ---
>>
>> Is this a stable fix for linux-3.3.y branch of compat-wireless or only
>> for the master branch ?
>>
> this is a stable fix (not very important one, though. only avoids some
> redundant compilations).

I just see this doing name changes for driver-select, how is this
fixing anything?

  Luis
