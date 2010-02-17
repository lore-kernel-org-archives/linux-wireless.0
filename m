Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f180.google.com ([209.85.210.180]:42933 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0BQQ4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 11:56:39 -0500
Received: by yxe10 with SMTP id 10so119945yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 08:56:38 -0800 (PST)
Message-ID: <4B7C1E82.4030005@lwfinger.net>
Date: Wed, 17 Feb 2010 10:51:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Frederic Leroy <fredo@starox.org>
CC: linux-wireless@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] staging: rtl8192su: remove dead code
References: <20100217091920.083a3dd3@houba>
In-Reply-To: <20100217091920.083a3dd3@houba>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2010 02:19 AM, Frederic Leroy wrote:
> Hello,
> 
> This patch removes some dead code in rtl8192su driver in staging against linux-2.6-stable tree.
> Should I split it into smaller chunk ? 
> As it is in staging, should I post it to linux-kernel@vger.kernel.org ?

At 1400+ lines, the patch is a little large. I would recommend that you separate
out the fixes for "ifdef RTL8190P" and "ifdef RTL8190U" into one patch, and the
changes for "ifdef TO_DO_LIST" into a couple of patches. That should get the
line count to below 500 in the individual patches.

These patches should be sent to GregKH with Cc: to linux-wireless and
linux-kernel@vger.kernel.org.

I'm not sure how you sent this patch, but when I extracted it from my mailer
(Thunderbird 3.0.1), it ended up with no line breaks. To get it as a usable
file, I had to copy and paste. Coordinators get rather testy when presented with
such patches.

Larry
