Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34344 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0IGRfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 13:35:08 -0400
Received: by qyk36 with SMTP id 36so3650763qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 10:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282764076.3667.12.camel@jlt3.sipsolutions.net>
References: <1282764076.3667.12.camel@jlt3.sipsolutions.net>
Date: Tue, 7 Sep 2010 10:35:05 -0700
Message-ID: <AANLkTikc0-FbeRHm-0rxrWCGgaxa7svCsQmqpAD-87cq@mail.gmail.com>
Subject: Re: libertas_tf
From: Steve deRosier <steve@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I'm actively working on it.  OLPC's XO-1.5 and also some Gumstix users
are using it right now.  In particular I've added an sdio interface
for the 8686 as well as some other general fixes.  I'm trying to get
it to a state to push it up to wireless-testing now.

If you or anyone else is interested, the details are on OLPC's wiki:
http://wiki.laptop.org/go/Thinfirm_1.5

- Steve

On Wed, Aug 25, 2010 at 12:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Is anyone using libertas_tf? I believe it has been broken since
> 2.6.34-rc1. Anyone want to fix it?
>
> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
