Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49401 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZIBRo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 13:44:58 -0400
Received: by fxm17 with SMTP id 17so964685fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 10:45:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251912629.2999.1.camel@johannes.local>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
	 <1251910457.13180.160.camel@rc-desk>
	 <1251911029.2999.0.camel@johannes.local>
	 <1251911825.13180.173.camel@rc-desk>
	 <1251912629.2999.1.camel@johannes.local>
Date: Wed, 2 Sep 2009 13:38:42 -0400
Message-ID: <cb0375e10909021038k32a576f1hd519e8dcdff9ef3d@mail.gmail.com>
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Andrew Lutomirski <luto@mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 2, 2009 at 1:30 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Hi Reinette,
>
>> The file itself was removed, but from what I understand the same
>> functionality can now be obtained from sleep_level_override.
>
> Indeed.
>
>> Users who
>> previously used power_level can thus now use sleep_level_override, but
>> with sleep_level_override not existing in 2.6.31 they will have no
>> alternative if we remove power_level.
>>
>> > So it
>> > may be fair to remove it for .31 since there you can't use it anyway.
>>
>> You can still use it to manually set power index used by device to
>> reduce power usage.
>
> I was under the impression that Andrew said this actually didn't work.

Exactly.  My patch fixes that, although there might be a better way to do that.

--Andy

>
> johannes
>
