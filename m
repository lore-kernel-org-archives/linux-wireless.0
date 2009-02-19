Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63328 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZBSFhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 00:37:34 -0500
Received: by bwz5 with SMTP id 5so606195bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 21:37:32 -0800 (PST)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Mysterious IWLWIFI_SPECTRUM_MEASUREMENT config
References: <87d4df1wfz.fsf@litku.valot.fi>
	<1234993225.12483.41.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 07:37:30 +0200
In-Reply-To: <1234993225.12483.41.camel@rc-desk> (reinette chatre's message of "Wed\, 18 Feb 2009 13\:40\:25 -0800")
Message-ID: <87zlgjhtr9.fsf@litku.valot.fi> (sfid-20090219_063741_955640_2DBED110)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> On Wed, 2009-02-18 at 09:33 -0800, Kalle Valo wrote:
>> I was doing my usual practise of recompiling my kernel and again I was
>> asked this question:
>> 
>> Enable Spectrum Measurement in iwlagn driver
>> (IWLWIFI_SPECTRUM_MEASUREMENT) [N/y/?] (NEW)
>> 
>> Ok, so I chose '?' and got this:
>> 
>> "This option will enable spectrum measurement for the iwlagn driver."
>> 
>> Not a very helpful message. I have few kind requests:
>> 
>> 1) Please write a proper description for the option.
>
> Will do.

Thanks. You will make the life of the users easier.

>> 2) Recommend a proper default value: "If you don't have a clue what
>>    this is, choose N".
>
> These are 802.11h measurements ... so typical users may not be
> interested. We'll make this a default N.

Good choice.

>> 3) Please consider even removing the option. Is it really needed?
>> 
>
> Some users may want this information so we'll keep it as an option for
> now. 

Not a problem when the option is properly documented, like you are
planning to do.

-- 
Kalle Valo
