Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49078 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0KBLKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 07:10:21 -0400
Received: by gxk23 with SMTP id 23so3913629gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 04:10:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288692717.24531.2.camel@chilepepper>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	<1288692717.24531.2.camel@chilepepper>
Date: Tue, 2 Nov 2010 13:10:20 +0200
Message-ID: <AANLkTinBeubKDzBKB9JUWcACWgLYvO9sdwUNtVde3tRF@mail.gmail.com>
Subject: Re: [PATCH 1/2] wl1271: handle HW watchdog interrupt
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 2, 2010 at 12:11 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> On Wed, 2010-10-27 at 14:09 +0200, ext Eliad Peller wrote:
>> unmask the WL1271_ACX_INTR_WATCHDOG interrupt.
>> when getting it - enqueue a recovery work and bail out.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Applied and fixed a couple of checkpatch "line over 80 characters"
> warnings.
>
> Please remember to *always* run checkpatch and fix any eventual
> warnings/errors before submitting.
>
will do.
thanks!
