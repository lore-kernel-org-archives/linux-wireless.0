Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62470 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2DRTJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 15:09:03 -0400
Received: by iagz16 with SMTP id z16so10797787iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 12:09:03 -0700 (PDT)
Message-ID: <4F8F114C.7080401@lwfinger.net> (sfid-20120418_210908_152027_06B79CE8)
Date: Wed, 18 Apr 2012 14:09:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: carl9170 firmware
References: <4F8DA785.6040608@lwfinger.net> <201204172035.06023.chunkeey@googlemail.com> <4F8DC439.103@lwfinger.net> <201204182026.49607.chunkeey@googlemail.com>
In-Reply-To: <201204182026.49607.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 01:26 PM, Christian Lamparter wrote:
> On Tuesday, April 17, 2012 09:27:53 PM Larry Finger wrote:
>> On 04/17/2012 01:35 PM, Christian Lamparter wrote:
>>> On Tuesday, April 17, 2012 07:25:25 PM Larry Finger wrote:
>>>> A question regarding adding carl9170-1.fw to the openSUSE firmware package is
>>>> being discussed on the oS kernel mailing list; however, I do not see that one
>>>> in the linux-firmware git repo. Should it be there?
>>> Does the repo take source code releases? [much like the work we do for the
>>> kernel driver, or have you ever seen a binary release on this ML :D ]. The
>>> files on<http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary>
>>> are just for convenience.
>>
>> AFAIK, the repo only takes binary files. With the source under GPL2, that should
>> not be a problem; however, the fact that there are two versions with the same
>> name would be trouble. Adding under that name has the possibility of breaking
>> all the systems that use the other version.
> I think I would need to read the opensuse ML discussion first to know why this
> is a "big" deal suddenly. (do you have a link?)
>
> On the other hand: I don't like the idea of supporting "old"&  "new" firmwares.
> Usually they get mixed up and then you end up with "new" reports for
> "old" bugs. In fact, p54 users' complain about that alot.

If the filename that the driver requests is changed, that should reduce the 
complaints. I would think that the current setup with two different, 
incompatible versions having the same name would be trouble.

The thread is at http://lists.opensuse.org/opensuse-kernel/2012-04/msg00040.html.

Larry

