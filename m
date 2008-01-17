Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:21262 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYAQSFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 13:05:25 -0500
Received: by py-out-1112.google.com with SMTP id u52so1067301pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 10:05:25 -0800 (PST)
Message-ID: <43e72e890801171005y50b1e1f4wff45cbaed867106f@mail.gmail.com> (sfid-20080117_180531_860939_47ADA4CF)
Date: Thu, 17 Jan 2008 13:05:24 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: Marc.Herbert@gmail.com
Subject: Re: no attachment [PATCH] compat-2.6: fix "make unload" / ieee80211_crypt_tkip
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801171306110.22400@maradi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <Pine.LNX.4.64.0801171306110.22400@maradi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 17, 2008 7:12 AM,  <Marc.Herbert@gmail.com> wrote:
> Re-sent without an "octet-stream" attachment, sorry. (gmail sucks)
>
>      -----------
>
> Hi there,
>
> I need this one-line patch for "make unload" to work on my Ubuntu
> gutsy.
>
> The actual reason is beyond me, but I'm sure one of you will figure it
> out and fix my fix in case it's not "the right thing".

This is correct, applied, thanks,

  Luis
