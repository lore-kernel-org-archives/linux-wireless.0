Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34152 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AWSJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 13:09:30 -0500
Received: by ggnb1 with SMTP id b1so1484486ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 10:09:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V26e6caZwCyO2chiZ_7iGVkoD_jtKsxfCLSHumrOp=Wg@mail.gmail.com>
References: <1327338154-3806-1-git-send-email-eliad@wizery.com>
	<CAB=NE6V26e6caZwCyO2chiZ_7iGVkoD_jtKsxfCLSHumrOp=Wg@mail.gmail.com>
Date: Mon, 23 Jan 2012 20:09:30 +0200
Message-ID: <CAB3XZEdo2zBRvyhv39jm98n146w_ppNmi-OR+VBTNj+ReuOyhg@mail.gmail.com> (sfid-20120123_190934_575269_FFEED40E)
Subject: Re: [PATCH] compat-wireless: fix wl12xx driver-select
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 7:23 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Mon, Jan 23, 2012 at 9:02 AM, Eliad Peller <eliad@wizery.com> wrote:
>> wl12xx is a possible choice for both group drivers and
>> singular modules (making it impossible to build only
>> the wl12xx module). change the group name to "ti" instead.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Is this a stable fix for linux-3.3.y branch of compat-wireless or only
> for the master branch ?
>
this is a stable fix (not very important one, though. only avoids some
redundant compilations).

Eliad.
