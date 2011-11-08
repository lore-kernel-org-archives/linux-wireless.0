Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1KHQHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:07:30 -0500
Received: by bke11 with SMTP id 11so535507bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 08:07:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320766462.24797.7.camel@jlt3.sipsolutions.net>
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
 <1320762928-6782-3-git-send-email-arik@wizery.com> <1320766462.24797.7.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 8 Nov 2011 18:07:13 +0200
Message-ID: <CA+XVXfeY+emYFLSx7qRy=ec2oXs=ZnF9KesvE8mcWD9=vYj-wg@mail.gmail.com> (sfid-20111108_170734_014346_C8ED72A6)
Subject: Re: [PATCH v3 3/3] mac80211: Save probe response data for bss
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 17:34, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
>
>> +     new = dev_alloc_skb(resp_len);
>> +     if (!new) {
>> +             printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
>> +                    "response template\n", sdata->name);
>
> I'm pretty sure that will already warn so the message is probably not
> very useful.

Sure. I'll remove it.
