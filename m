Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58695 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940Ab0KQBrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 20:47:48 -0500
Received: by qyk12 with SMTP id 12so5765510qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 17:47:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289946246.3673.12.camel@jlt3.sipsolutions.net>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com> <1289946246.3673.12.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 16 Nov 2010 17:41:34 -0800
Message-ID: <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Nov 16, 2010 at 2:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-11-15 at 16:27 -0800, Javier Cardona wrote:
>> This patch: http://osdir.com/ml/linux-wireless/2009-11/msg00981.html
>> kicked the command to manage mesh plinks into non-existence.  Here we
>> bring it back under a different name.
>
> I'll happily take this, but would you prefer to have the other one
> backed out instead?

That would save us and some of our clients from having to change a
bunch of scripts, yes.

Thanks,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
