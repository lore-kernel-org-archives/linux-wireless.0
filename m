Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbcBJCAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 21:00:08 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Drunk Cat <natserver2@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
References: <loom.20160128T003525-188@post.gmane.org>
	<wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
	<wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
	<56BA8E5D.5090402@lwfinger.net>
Date: Tue, 09 Feb 2016 21:00:06 -0500
In-Reply-To: <56BA8E5D.5090402@lwfinger.net> (Larry Finger's message of "Tue,
	9 Feb 2016 19:11:57 -0600")
Message-ID: <wrfjlh6tb9zt.fsf@redhat.com> (sfid-20160210_030012_386049_4A0E149E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 02/09/2016 03:00 PM, Jes Sorensen wrote:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>> I can confirm what Drunk Cat sees. There is something different about
>>>> the RTL8192RU as using the iwconfig utility shows no APs in the
>>>> scan. I hope to get to debugging the problem soon.
>>>
>>> OK - thats unfortunate. Most likely the wrong antenna path is being
>>> enabled for it, or something like that.
>>>
>>> Once I finish up the 8723bu/8192eu patchset, I'll try to find some time
>>> to look at it, if you don't nail it before.
>>
>> One more time with the actual patch ...
>
> No help. The name of the patch makes it sound as if it is for a 1T2R
> device. The RTL8188RU is 1x1.

Darn, I didn't have an 8188RU near me when I discovered that bug and so
I wasn't sure if it was 1T2R or 1T1R. All my other 1T1R parts work
fine with the current code.

Cheers,
Jes
