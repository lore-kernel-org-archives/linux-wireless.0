Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:64633 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZCZP0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 11:26:40 -0400
Received: by qyk16 with SMTP id 16so1068736qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 08:26:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238078762.4331.38.camel@johannes.local>
References: <1238066858.4331.30.camel@johannes.local>
	 <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com>
	 <1238078762.4331.38.camel@johannes.local>
Date: Thu, 26 Mar 2009 11:26:37 -0400
Message-ID: <b6c5339f0903260826t58c8c595ve612fa35ba7c91e4@mail.gmail.com> (sfid-20090326_162643_069541_BE749AC0)
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 10:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> Could we use some newfangled thing like tracepoints for this
>> instead of printk? =A0Disclaimer: I know nothing about such
>> things.
>
> Probably. Want to look at how to do that? :)

Sure, I'll do some research and see what's involved.  Don't hold
up the patch on my account though.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
