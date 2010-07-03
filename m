Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab0GCTgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jul 2010 15:36:45 -0400
Message-ID: <4C2F8F27.50405@redhat.com>
Date: Sat, 03 Jul 2010 15:27:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@atheros.com,
	linville@tuxdriver.com
Subject: Re: ath: Fix uninitialized variable warnings [v2]
References: <20100701160048.23795.39782.sendpatchset@prarit.bos.redhat.com> <1278165872.6710.1.camel@mj>
In-Reply-To: <1278165872.6710.1.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/03/2010 10:04 AM, Pavel Roskin wrote:
> On Thu, 2010-07-01 at 12:09 -0400, Prarit Bhargava wrote:
>   
>> Fix 'make CONFIG_DEBUG_SECTION_MISMATCH=y' warning:
>>     
> I don't think the warnings you are fixing have anything to do with
> CONFIG_DEBUG_SECTION_MISMATCH.
>   

Actually, Pavel -- they do.  I've already emailed a question to some of
the gcc developers to see if they can explain to me why *I only see
these warnings if CONFIG_DEBUG_SECTION_MISMATCH is enabled*. 

I agree, however, that it shouldn't make a difference and that it may
show a bug in gcc or somewhere in our makefiles.

>> drivers/net/wireless/mwl8k.c: In function 'mwl8k_bss_info_changed_sta':
>> drivers/net/wireless/mwl8k.c:3404: warning: 'ap_legacy_rates' may be used uninitialized in this function
>>     
> The patch doesn't appear to touch mwl8k.c at all.
>
> Please fix the description.
>
>   

Will do -- sorry, I cut-and-pasted too much...

P.
