Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60738 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0JJMZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 08:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <1286707450.3547.8.camel@jlt3.sipsolutions.net>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
	<dc990a5f703e69ed428ac2f2479779d36ef1eb3f.1286705921.git.andy.shevchenko@gmail.com>
	<1286707450.3547.8.camel@jlt3.sipsolutions.net>
Date: Sun, 10 Oct 2010 15:25:04 +0300
Message-ID: <AANLkTi=v=VsMGM3WyAF=6g8pV2j3OMHVvixmWpz4FOaO@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: brcm80211: fix to use "%pM" flag to print
 MAC address
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 10, 2010 at 1:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> +     snprintf(buf, 18, "%pM", ea->octet);
>
> That's a pretty strange use of snprintf -- just use sprintf if you don't
> have a real buffer length.
Exactly. However, it's out of scope of this certain patch.

It should be done as a fix across entire driver.

-- 
With Best Regards,
Andy Shevchenko
