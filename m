Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37339 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab2HISnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:43:20 -0400
Message-ID: <502404BD.1030809@hauke-m.de> (sfid-20120809_204358_454721_9786C066)
Date: Thu, 09 Aug 2012 20:43:09 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/13] Merge GSoC DRM changes to admin-update.sh
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com> <CA+icZUWTjKYQ5YZfx488=SJA-uYYoRvM5X=Gh0YOHn8SvUM2jg@mail.gmail.com> <CA+icZUU5SXppB1f3HRKGo3RaUfNF=yWXM=4sAyRJ92FcMi=2Ag@mail.gmail.com>
In-Reply-To: <CA+icZUU5SXppB1f3HRKGo3RaUfNF=yWXM=4sAyRJ92FcMi=2Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 08:36 PM, Sedat Dilek wrote:
> On Thu, Aug 9, 2012 at 8:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Aug 9, 2012 at 8:01 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>>> Hi,
>>>
>>> The patches below modifies the admin-update.sh script so that it
>>> accepts a variable-length last argument, namely network or/and drm,
>>> to selectively fetch specific subsystem codes into the tree.
>>>
>>> The last 2 patches constitutes the work done so far for the my
>>> GSoC project.
>>>
>>> This first attempt is mostly for getting some comments. For example,
>>> eventhough you fetch network and drm drivers, make will just build
>>> network drivers. I will either port the project to kconfig which
>>> will dynamically configure and build what's available or hack
>>> config.mk and Makefile to detect the availability of other drivers
>>> than the wireless ones.
>>>
>>> I thank Luis R. Rodriguez, my mentor, for his helpful and highly
>>> responsive mentorship :)
>>>
>>> Ozan Çağlayan (13):
>>>   compat-wireless: Clean up *.mod.c once after everything
>>>   compat-wireless: Isolate drivers into different groups
>>>   compat-wireless: List everything vertically without concatenating
>>>   compat-wireless: Add ability to enable/disable subsystems
>>>   compat-wireless: Add 2 convenience functions
>>>   compat-wireless: Conditionally build network drivers
>>>   compat-wireless: Put network patches into its directory
>>>   compat-wireless: No need to search for patches
>>>   compat-wireless: Fix cmdline parameter's name
>>>   compat-wireless: Selectively apply patches
>>>   compat-wireless: Move refresh logic into the loop
>>>   compat-wireless: Fetch in DRM drivers
>>>   compat-wireless: Add DRM patches
>>>
>>
>> Am I the only one missing 07/13 in series?
>> On [1] I do not see, too.
>>
>> - "Birinci" Sedat -
>>
>> [1] http://marc.info/?l=linux-wireless&r=1&b=201208&w=2
>>
> 
> Looks like "compat-wireless: Put network patches into its directory"
> is the missing one.
> 
> - Sedat -
The patch was probably too big for the mailing list. Ozan do you have a
git tree to pull from or could you put it on some web server.

Hauke

