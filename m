Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48046 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1EEErP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 00:47:15 -0400
Received: by wwa36 with SMTP id 36so1938288wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 21:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC1B2F3.3070300@lwfinger.net>
References: <4DC1AF49.7080204@lwfinger.net>
	<1304539363.3563.28.camel@jlt3.sipsolutions.net>
	<4DC1B2F3.3070300@lwfinger.net>
Date: Thu, 5 May 2011 10:17:13 +0530
Message-ID: <BANLkTinty0_+FvOiP2Yag=gdvm73TkOwiQ@mail.gmail.com> (sfid-20110505_064731_228232_A01422BA)
Subject: Re: WARNING from mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2011 at 1:41 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/04/2011 03:02 PM, Johannes Berg wrote:
>>
>> On Wed, 2011-05-04 at 14:55 -0500, Larry Finger wrote:
>>>
>>> Johannes and John,
>>>
>>> A regression in recent versions of mac80211 are generating the WARNING at
>>> net/mac80211/wep.c:101, because the skb headroom is less than WEP_IV_LEN
>>> or the
>>> tailroom is less than WEP_ICV_LEN. My testing indicates that it is a
>>> headroom
>>> problem as the following hack "fixes" it:
>>
>> See also this thread:
>>
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/69062/focus=69150
>>
>> and the resulting patch:
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/69190
>> (not sure why it was RFC?)

I will send the patch today :)

thanks,
shafi

>
> Thanks. I do remember the thread now that you refreshed my memory. That
> patch does fix my problem.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
