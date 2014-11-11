Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:37733 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaKKSc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 13:32:57 -0500
Received: by mail-oi0-f50.google.com with SMTP id v63so7417070oia.37
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 10:32:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5461EE3B.8040301@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
	<CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com>
	<5461EE3B.8040301@broadcom.com>
Date: Tue, 11 Nov 2014 12:32:56 -0600
Message-ID: <CAMP44s10T_mxqLigrPf_Ox4jej--87QmjG7cNjT8o_qyU2HXjg@mail.gmail.com> (sfid-20141111_193308_009412_3B2CEBD1)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2014 at 5:08 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 10-11-14 21:48, Felipe Contreras wrote:

>> /etc/modprobe.d/brcmfmac.conf
>> options brcmfmac debug=0xd416
>>
>> I see nothing extra in the debug log... Am I doing something wrong?
>
> Not sure. You can verify and set the log level through sysfs, ie.:
>
> $ cat /sys/module/brcmfmac/parameters/debug

54294

I guess ArchLinux's kernel is missing some configuration option needed
for the debugging.

-- 
Felipe Contreras
