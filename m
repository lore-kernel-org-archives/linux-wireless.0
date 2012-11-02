Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34148 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588Ab2KBBpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 21:45:38 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so2356658iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2012 18:45:37 -0700 (PDT)
Message-ID: <509325BA.2060807@lwfinger.net> (sfid-20121102_024552_526143_70C0BE6C)
Date: Thu, 01 Nov 2012 20:45:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Akira Nonaka <nonaka@mac.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8723e disconnect problem on the kernel 3.4.9.
References: <509200A2.9060300@mac.com> <50929F0C.5060501@lwfinger.net> <50931EEC.9040606@mac.com>
In-Reply-To: <50931EEC.9040606@mac.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2012 08:16 PM, Akira Nonaka wrote:
> Larry,
> 
>> (2) Are the memset errors fixed? There are a number of calls where args 2 and 3
>> are reversed.
> 
> Yes, I found there are a few wrong memset() call in the efuse.c.

Those are all fixed in my patch. The driver that you are using was my starting
point for the one that will be included in the kernel. My experience is that the
connections that I get are extremely stable, particularly for a new driver.

Larry


