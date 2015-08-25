Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34962 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbHYKfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 06:35:11 -0400
Received: by wicne3 with SMTP id ne3so10740374wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 03:35:10 -0700 (PDT)
Date: Tue, 25 Aug 2015 12:35:04 +0200 (CEST)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Sreenath Madasu <Sreenath.Madasu@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: Getting started on switching rtl8188eu staging driver to
 LIB80211/MAC80211
In-Reply-To: <loom.20150824T013723-25@post.gmane.org>
Message-ID: <alpine.LNX.2.00.1508251226170.16623@T520.work> (sfid-20150825_123517_041593_D2EC0AD5)
References: <loom.20150824T013723-25@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Sun, 23 Aug 2015, Sreenath Madasu wrote:

> Hi all,
> I want to work on the TODO tasks
> 
> - switch to use LIB80211
> - switch to use MAC80211
> 
> for staging driver rtl8188eu.
> 
> How can I start? Where is the documentation?
> Thanks
> Sreenath
> 

I have the same problems with my RTL8821AU driver.
But I'm currently switching to rtlwifi-lib and of course 
LIB80211/MAC80211.

Take the rtl8188ee as an example to rewrite/rename all functions in 
hal/
os_dep/

You can also look at my repo at
github.com/ulli-kroll/rtl8821au.git

Greeting form Cologne
Hasn Ulli Kroll


> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
