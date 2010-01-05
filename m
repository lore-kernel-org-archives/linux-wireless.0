Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46245 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab0AEKxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:53:39 -0500
Received: by bwz27 with SMTP id 27so9814067bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 02:53:37 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
Subject: Re: [RFC PATCH v5 2/7] mac80211: add debugfs interface for U-APSD queue configuration
References: <20091231133626.29899.95683.stgit@tikku>
	<20091231133720.29899.75214.stgit@tikku>
	<1262684902.21956.1.camel@johannes.local>
	<87vdfgvobq.fsf@purkki.valot.fi>
	<1262688248.23910.10.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 12:53:35 +0200
In-Reply-To: <1262688248.23910.10.camel@johannes.local> (Johannes Berg's message of "Tue\, 05 Jan 2010 11\:44\:08 +0100")
Message-ID: <87my0svn4g.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2010-01-05 at 12:27 +0200, Kalle Valo wrote:
>
>> I'll store the values shifted in local->uapsd_max_sp_len and do the
>> conversion in debugfs.c.
>
> Ok, but please add a comment then to the field that it's already
> shifted, typically we store values as per spec (0,1,2,3) and then put
> them into the right bitmap position when using them.

Oh, I didn't know that. In that case I do the shift when creating the
frame :)

Thanks again.

-- 
Kalle Valo
