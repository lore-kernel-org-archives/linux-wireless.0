Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42370 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2LEMUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 07:20:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3540330pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 04:20:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354706476.6234.50.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
 <1354095769-8724-6-git-send-email-arik@wizery.com> <1354706476.6234.50.camel@cumari.coelho.fi>
From: Eyal Shapira <eyal@wizery.com>
Date: Wed, 5 Dec 2012 14:19:53 +0200
Message-ID: <CAF8O4-xizhg8T4eQ13BGLR=ZDYz95+6zEWjW8HchW7CfUrfQMQ@mail.gmail.com> (sfid-20121205_132017_990777_20C108D7)
Subject: Re: [PATCH 05/20] wlcore: increase scan dwell times if no activity
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 December 2012 13:21, Luciano Coelho <coelho@ti.com> wrote:
>
>
> IMO it would have been nicer to keep the existing ones as they are and
> not change the semantics.  Then add the new ones with another name.
> Maybe something like "max_dwell_time_active_long", which is more
> generic.
>
> It is possible that we will find more scenarios where this long scans
> could be used (eg. if it would be possible to identify whether there are
> any low latency TIDs running or not).
>

Sure. I'll respin it.
