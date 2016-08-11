Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36826 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbcHKS6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 14:58:36 -0400
Received: by mail-qk0-f178.google.com with SMTP id l2so4662134qkf.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2016 11:58:35 -0700 (PDT)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
To: Denis Kenzior <denkenz@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
 <1470919643.12075.7.camel@sipsolutions.net> <57ACA9E9.4020507@gmail.com>
 <1470938627.12075.25.camel@sipsolutions.net> <57ACC1F8.6070908@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f2fe3568-0b83-9db4-278e-be0a1ad08ae8@broadcom.com> (sfid-20160811_205840_593140_E3DEF7B8)
Date: Thu, 11 Aug 2016 20:58:28 +0200
MIME-Version: 1.0
In-Reply-To: <57ACC1F8.6070908@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-8-2016 20:20, Denis Kenzior wrote:
> Hi Johannes,
> 
>>> Speaking of indentation, can you point me to a doc of the rules I
>>> should follow?
>>
>> You've seen Documentation/CodingStyle?
> 
> Of course.  But that one doesn't discuss that you want your function
> parameters to be aligned to the opening '('.  Is there a dialect
> document specific to linux-wireless?

You can find it in checkpatch.pl [1] :-p

Regards,
Arend

[1] http://lxr.free-electrons.com/source/scripts/checkpatch.pl#L2855
