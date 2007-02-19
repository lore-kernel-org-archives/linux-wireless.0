Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:12365 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965543AbXBSXbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 18:31:43 -0500
Received: by an-out-0708.google.com with SMTP id b33so256314ana
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2007 15:31:43 -0800 (PST)
Message-ID: <40f31dec0702191531q7aadf2b9l4e7836630e9d5aa6@mail.gmail.com>
Date: Tue, 20 Feb 2007 01:31:42 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: What about dadwifi and openhal?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200702192153.19458.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <200702192153.19458.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yup try dadwifi-openhal branch from here...

http://svn.madwifi.org/branches/dadwifi-openhal

It still needs some work but it has the same functionality as plain
dadwifi (with the binary HAL) at least for me, i'm cleaning up openhal
so there is no HAL (all-in-one solution cause chipsets are much
similar after all) and Pavel works on the driver part (makes most of
the work actually :P).

we 're currently working some things out and we'll be up and running soon ;-)

We need some time to organize etc (site/repository etc) so as Luis
said just give us a couple of days.

2007/2/19, Michael Buesch <mb@bu3sch.de>:
> There were biiig discussions about dadwifi and openhal
> a few weeks ago. About merging them and about inclusion
> in wireless-dev.
>
> Is something actually happening?
> Is openhal being ported to dadwifi?
> Who is working on it?
> Can I help?
>
> --
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
As you read this post global entropy rises. Have Fun ;-)
Nick
