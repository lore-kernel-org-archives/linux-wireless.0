Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54118 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0HGRUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 13:20:14 -0400
Message-ID: <4C5D95C6.4060301@hauke-m.de>
Date: Sat, 07 Aug 2010 19:20:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 2/4] compat: move va_format to compat-2.6.36.h
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>	 <1281187941-7168-3-git-send-email-hauke@hauke-m.de> <1281196236.4431.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1281196236.4431.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 07.08.2010 17:50, schrieb Johannes Berg:
> On Sat, 2010-08-07 at 15:32 +0200, Hauke Mehrtens wrote:
>> This struct was introduced in kernel 2.6.36 and not 2.6.35.
> 
> I'm confused now:
> 
> $ git describe 7db6f5fb
> v2.6.35-rc1-928-g7db6f5f
> 
> johannes
> 
Hi,

I am also confused. ;-) I get the same result for git describe 7db6f5fb
as you.

But include/linux/kernel.h does not contain struct va_format in kernel
2.6.35 it was added sometime later.

Without adding struct va_format to compat-2.6.36.h I get build error
with kernel 2.6.35.

Hauke
