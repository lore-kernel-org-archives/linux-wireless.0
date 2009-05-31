Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34365 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZEaSVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 14:21:12 -0400
Received: by ewy24 with SMTP id 24so7372966ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 11:21:13 -0700 (PDT)
Message-ID: <4A22CAD4.1010507@tuffmail.co.uk>
Date: Sun, 31 May 2009 19:22:12 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243524688.10632.0.camel@johannes.local>	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com> <1243778069.5299.0.camel@johannes.local>
In-Reply-To: <1243778069.5299.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> How should userspace test CONFIG_RFKILL_INPUT to determine whether
>> it's safe to start the daemon?  With the old core, debian-eeepc
>> scripts check if the module rfkill-input exists (which should work
>> even if it's built in).  If it exists, the scripts don't perform any
>> rfkill actions.  (Yeah, according to the doc this is not allowed
>> because the scripts don't use "claim", but you can see how it's
>> useful).
>>
>> The new rfkill-input isn't a module, so I'm not sure how your daemon
>> would test for it.
>>     
>
> Maybe we should add an ioctl that disables rfkill-input if present.
>
> johannes
>   

Sounds good.
