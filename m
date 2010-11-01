Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39361 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0KAU7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 16:59:53 -0400
Received: by gxk23 with SMTP id 23so3548562gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 13:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288617893.20937.10.camel@chilepepper>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	<1288181398-2358-2-git-send-email-eliad@wizery.com>
	<1288617893.20937.10.camel@chilepepper>
Date: Mon, 1 Nov 2010 22:59:51 +0200
Message-ID: <AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> add RECOVER testmode command.
>> this command triggers a recovery sequence (by enqueueing a recovery_work).
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> So, the point of this patch is to allow hardware recovery from the
> userspace? In what kind of scenario do you need this?
>

yes.
it's mainly for testing (or if we want to recover manually for some reason).
this is why i implemented it as a testmode command.

i added it after observing some recovery issues (until applying
Juuso's "wl1271: Check interface state in op_* functions" :) )

Eliad.
