Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:47644 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKKStO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 13:49:14 -0500
Received: by mail-oi0-f48.google.com with SMTP id x69so7364950oia.7
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 10:49:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546256E3.1080606@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
	<CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com>
	<5461EE3B.8040301@broadcom.com>
	<CAMP44s10T_mxqLigrPf_Ox4jej--87QmjG7cNjT8o_qyU2HXjg@mail.gmail.com>
	<546256E3.1080606@broadcom.com>
Date: Tue, 11 Nov 2014 12:49:14 -0600
Message-ID: <CAMP44s3r7DS6eR4pDqesv1JeiWsC-j75QGdGJk=PBX208sUJ1g@mail.gmail.com> (sfid-20141111_194918_046551_C774F701)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2014 at 12:35 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11-11-14 19:32, Felipe Contreras wrote:
>> On Tue, Nov 11, 2014 at 5:08 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 10-11-14 21:48, Felipe Contreras wrote:
>>
>>>> /etc/modprobe.d/brcmfmac.conf
>>>> options brcmfmac debug=0xd416
>>>>
>>>> I see nothing extra in the debug log... Am I doing something wrong?
>>>
>>> Not sure. You can verify and set the log level through sysfs, ie.:
>>>
>>> $ cat /sys/module/brcmfmac/parameters/debug
>>
>> 54294
>>
>> I guess ArchLinux's kernel is missing some configuration option needed
>> for the debugging.
>
> Can you boot the kernel with 'debug ignore_loglevel' on the kernel
> command line.

Yes. I see more systemd messages, nothing extra from brcmfmac.

-- 
Felipe Contreras
