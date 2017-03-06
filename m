Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32809 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752768AbdCFMfO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 07:35:14 -0500
Subject: Re: [PATCH] mac80211: Use setup_timer instead of init_timer
To: Johannes Berg <johannes@sipsolutions.net>
References: <20170303124535.30125-1-jslaby@suse.cz>
 <1488803104.5761.6.camel@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Ond=c5=99ej_Lyson=c4=9bk?= <ondrej.lysonek@seznam.cz>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <7545a8ad-ec74-ed01-d84d-9ef4528b21df@suse.cz> (sfid-20170306_133554_318107_A5CA214A)
Date: Mon, 6 Mar 2017 13:35:10 +0100
MIME-Version: 1.0
In-Reply-To: <1488803104.5761.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2017, 01:25 PM, Johannes Berg wrote:
> On Fri, 2017-03-03 at 13:45 +0100, Jiri Slaby wrote:
>> From: Ondřej Lysoněk <ondrej.lysonek@seznam.cz>
>>
>> Use setup_timer() and setup_deferrable_timer() to set the data and
>> function timer fields. It makes the code cleaner and will allow for
>> easier change of the timer struct internals.
> 
> Btw, I suspect you generated this with coccinelle and didn't put enough
> "..." there, because you missed one in mesh_path_new() :)

Not really. This is one of assignments for students I lead, so this is
done by hand every end of winter semester (Note the From line.)

> Care to send a patch for that one too?

I am just a forwarder, he received this request too, so you can try to
persuade him :).

thanks,
-- 
js
suse labs
