Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38593 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032897AbbKEGlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 01:41:05 -0500
Received: by wmeg8 with SMTP id g8so4400815wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 22:41:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <563A9B8C.3060503@candelatech.com>
References: <563A9B8C.3060503@candelatech.com>
Date: Thu, 5 Nov 2015 07:41:03 +0100
Message-ID: <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com> (sfid-20151105_080710_589478_5E61DC5E)
Subject: Re: Configurable scan dwell time?
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 November 2015 at 00:58, Ben Greear <greearb@candelatech.com> wrote:
> It looks to me like the channel dwell time when scanning (SW scanning,
> mac80211)
> is fixed at 1/9 of a second.  I'd like to make this configurable...is that
> something
> that might be welcome upstream?
>
> My plan is to add to the netlink API around starting a scan and allow
> user-space to
> configure a dwell time in milliseconds.

I've actually tried doing something like this some time ago:

 - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111255
 - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111251


Michał
