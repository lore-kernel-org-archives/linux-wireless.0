Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:45572 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0ANREs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 12:04:48 -0500
Message-ID: <4B4F4EB1.7020300@pardus.org.tr>
Date: Thu, 14 Jan 2010 19:04:49 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: Some remarks about compat-wireless KBuild system
References: <4B4DFCA8.6020006@pardus.org.tr> <3ace41891001131903g38f4da27w6f469e6121eaf668@mail.gmail.com>
In-Reply-To: <3ace41891001131903g38f4da27w6f469e6121eaf668@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Wed, Jan 13, 2010 at 5:02 PM, Ozan Çağlayan <ozan@pardus.org.tr> wrote:
>> Hi,
>>
>> Current compat-wireless build system has some inconveniences for distribution packaging:
>>
>>
>> - In Makefile, KLIB is set to /lib/modules/$(uname -r) which avoids compiling the stack
>> against a non-running kernel. In several other external kernel drivers this can be bypassed
>> by giving KERNELRELEASE=something to "make" but it's not working for compat-wireless.
> 
> Did you not read README (or the instruction in the README not working
> any more)?
> 
> compat-wireless can be used with a non-running kernel, and the
> instruction is in the top-level README. (I contributed part of it, the
> part on the non-running kernel which has just been distro-installed,
> e.g. to build and install compat-wireless during a routine upgrade
> which installs a new kernel but before a reboot to it).

Hi,

actually yes I've read it many times to not miss anything about packaging but I didn't see that part.
The instructions are still correct and building against a non-running kernel and installing to a different
directory works without problem.

sorry for the inconvenience, thanks!
Ozan Caglayan
