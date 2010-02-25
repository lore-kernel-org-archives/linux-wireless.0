Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44151 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0BYReE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:34:04 -0500
Received: by gwj16 with SMTP id 16so1832030gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 09:34:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267099415.3796.4.camel@jlt3.sipsolutions.net>
References: <1267099415.3796.4.camel@jlt3.sipsolutions.net>
Date: Thu, 25 Feb 2010 09:33:59 -0800
Message-ID: <445f43ac1002250933l52a2dc1eg43f1902165f1de07@mail.gmail.com>
Subject: Re: libertas_tf maintenance status
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Deepak Saxena <dsaxena@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Feb 25, 2010 at 4:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> What's the maintenance status on libertas_tf?

No one from cozybit is currently maintaining this driver.  Maybe
Deepak (cc:), from OLPC?

> Now that we have async firmware loading that is more capable, I would
> love to see libertas_tf converted to load firmware before registering
> with mac80211, like ar9170 and iwlwifi, and register with the right MAC
> address so we can get rid of the code that was added by
>
> commit bdbe819540f3365249095692118dbfeee308140d
> Author: Luis Carlos Cobo <luisca@cozybit.com>
> Date:   Thu Aug 14 10:40:48 2008 -0700
>
>   mac80211: allow no mac address until firmware load

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
