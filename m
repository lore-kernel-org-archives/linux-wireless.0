Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([74.45.170.26]:42008 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbaD3NiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 09:38:01 -0400
Message-ID: <5360FCB2.6000605@canonical.com> (sfid-20140430_153805_427060_E20B634B)
Date: Wed, 30 Apr 2014 07:37:54 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Sven Eckelmann <sven@narfation.org>
CC: Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox> <535FC896.1080604@lwfinger.net>
In-Reply-To: <535FC896.1080604@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2014 09:43 AM, Larry Finger wrote:
> On 04/29/2014 02:42 AM, Sven Eckelmann wrote:
>> On Monday 28 April 2014 10:44:01 Larry Finger wrote:
>> [...]
>>> Is there a link to the 3.8.0-37 source? I could not find it on the
>>> Ubuntu
>>> web pile. With it, I should be able to fix his problem as long as I can
>>> duplicate it.
>>
>> Which exact versions? 3.8.0-36.52~precise1 and 3.8.0-37.53~precise1?
>> There were
>> a lot of backports which you can find all here:
>> https://launchpad.net/ubuntu/+source/linux-lts-raring/+publishinghistory
>>
>> You can just click on the version number at the right to find the
>> *.tar.gz,
>> *.diff.gz and *.dsc.
>>
>> You can download and create a source directory using
>>
>> dget
>> https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-36.52~precise1/+files/linux-lts-raring_3.8.0-36.52~precise1.dsc
>>
>> or
>> dget
>> https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-37.53~precise1/+files/linux-lts-raring_3.8.0-37.53~precise1.dsc
>>
>
> Sven,
>
> Thanks for the info. I wanted version 3.8.0-37.53~precise1, but given
> that the code is available as the original source and the diff, I also
> grabbed the diff file for 3.8.0-36.52~precise1. My test kernel is
> building now.
>
> Larry
>
>

Larry - you can also get the source from our git repository:

git://kernel.ubuntu.com/ubuntu/ubuntu-precise.git

You can get the most recent source for that version from the 
lts-backport-raring branch, or use the tag Ubuntu-lts-3.8.0-37.53

Thanks for looking into this. Let me know if I can help.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
