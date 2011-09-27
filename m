Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1I0VIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 17:08:36 -0400
Received: by eya28 with SMTP id 28so5110251eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 14:08:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317123991.4082.17.camel@jlt3.sipsolutions.net>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
 <1317034493-5300-3-git-send-email-arik@wizery.com> <1317123991.4082.17.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 28 Sep 2011 00:08:20 +0300
Message-ID: <CA+XVXfck57AoZXG6rYX9Lue0=H2Lv=k1cyy4-HGXp=F_P1MH6g@mail.gmail.com> (sfid-20110927_230839_570466_7E57D396)
Subject: Re: [PATCH 2/5] mac80211: standardize adding supported rates IEs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 14:46, Johannes Berg <johannes@sipsolutions.net> wrote:
>> +EXPORT_SYMBOL(ieee80211_add_srates_ie);
>
>> +EXPORT_SYMBOL(ieee80211_add_ext_srates_ie);
>
> You shouldn't export these.
>
>> \ No newline at end of file
>
> And it's a good idea to have "\n" be the last character of the file :)
>

Will do.

Arik
