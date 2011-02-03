Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41185 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1BCQNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 11:13:14 -0500
Received: by qyj19 with SMTP id 19so7253105qyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 08:13:14 -0800 (PST)
Message-ID: <4D4AD44C.4070409@lwfinger.net>
Date: Thu, 03 Feb 2011 10:14:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	zhaoming_li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: rtl8192ce: Modify core for inclusion of additional
 drivers
References: <1296324761-14158-1-git-send-email-Larry.Finger@lwfinger.net> <20110203102331.GA3516@redhat.com>
In-Reply-To: <20110203102331.GA3516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2011 04:23 AM, Stanislaw Gruszka wrote:
> On Sat, Jan 29, 2011 at 12:12:41PM -0600, Larry.Finger@lwfinger.net wrote:
>> From: zhaoming_li <chaoming_li@realsil.com.cn>
> 
>> Unfortunately, this is a much larger patch than I would like, but the
>> changes are substantial. I tried to keep any white-space changes to a
>> minimum. My attempts to split the patch into separate pieces resulted
>> in compilation errors, which would break bisection.
> 
> But zhaoming_li did not change code in one big commit like that,
> zhaoming_li did you? :-)
> 
> It would be better if realsil will send small patches when
> they are created, instead of develop driver behind closed doors
> and then post changes in one huge hunk.

I agree; however, the situation is even more complicated. The Realsil group in
China now has mac80211 drivers for 3 PCI-based devices, and the Realtek group in
Taiwan has a similar driver for a USB-based device. Drivers for each of the 2
new PCI devices and the USB device were sent to me as a complete package. I'm
trying to merge them with as little effort as possible, which resulted in that
large patch.

I'll back off and take it in smaller steps to make it easier to review. Once we
get these three new drivers merged, then any further changes will be as
incremental patches.

As these 802.11N devices are starting to appear in late-model laptops,
particularly those made by Toshiba, it is important to merge these drivers ASAP.

Larry


