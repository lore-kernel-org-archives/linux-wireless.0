Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39326 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2EWKtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 06:49:41 -0400
Received: by bkcji2 with SMTP id ji2so5830059bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 03:49:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wr436utp.fsf@purkki.adurom.net>
References: <1337760813-27055-1-git-send-email-arik@wizery.com> <87wr436utp.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 23 May 2012 13:49:22 +0300
Message-ID: <CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com> (sfid-20120523_124944_641303_FA01F594)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2012 at 1:44 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Arik Nemtsov <arik@wizery.com> writes:
>
>> Allow the low level driver to set U-APSD parameters when operating in
>> managed mode.
>
> Why? I assume there is a reason for this...

Of course. We want to change this in wlcore. We've encountered
compatibility problems with some APs when we set ACs other than VO to
U-APSD mode.

Arik
