Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42296 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab3EVTzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 15:55:51 -0400
Received: by mail-wg0-f50.google.com with SMTP id k13so1642757wgh.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 12:55:49 -0700 (PDT)
References: <519D0D44.1040901@pdm.ac.in>
Mime-Version: 1.0 (1.0)
In-Reply-To: <519D0D44.1040901@pdm.ac.in>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <14ECE0C4-AE53-4CC5-B6B6-42930C2C26FB@gmail.com> (sfid-20130522_215554_034191_DC53AD7F)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Ralink RT3290 proprietary drivers causing kernel panic
Date: Wed, 22 May 2013 21:55:46 +0200
To: Mohit <mt1037ag11@pdm.ac.in>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohit,

Sent from my iPad

On 22 mei 2013, at 20:24, Mohit <mt1037ag11@pdm.ac.in> wrote:

> Hello,
> 
>          I am on openSUSE 12.3 with kernel 3.7.10-1.4-desktop, i wanted to try out the proprietary drivers for Ralink RT3290 so i downloaded the drivers from http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501 and compiled the drivers as mentioned on my thread here : https://forums.opensuse.org/english/get-technical-help-here/wireless/486975-rt3290-wireless-proprietary-drivers-not-working.html#post2557514. Everything compiled fine, openSUSE was able to scan and connect to access points after installation, but when i access the internet a kernel panic occurs after ~5sec (time varies based on the data usage). So i humbly request you to please provide the solution for the same, you can reach me through email or reply to my thread (probably faster as i don't check my email everyday).
> 

You'll have to contact Mediatek about the drivers that you downloaded from their web site.
None of us on this mailing list have created this driver, nor are we supporting it.

Note that the standard kernel does contain support for the RT3290 chipset in its rt2x00 driver since kernel version 3.6 or 3.7, so you might give that a try.

---
Gertjan