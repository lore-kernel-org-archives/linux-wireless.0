Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61439 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1ATLRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 06:17:25 -0500
Received: by qwa26 with SMTP id 26so486607qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 03:17:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F05954D@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
	<400C43189542CE41BC0A5B252FC90136952F05954D@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Thu, 20 Jan 2011 12:12:16 +0100
Message-ID: <AANLkTimfw+tj6-NBRhdwkG0MoOV5YS3qe6LSoa=Gr6C7@mail.gmail.com>
Subject: Re: [RFT 0/8] Clean proto/ethernet.h and remove it.
From: Jonas Gorski <jonas.gorski@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 20/01/2011, Arend Van Spriel <arend@broadcom.com> wrote:
> The brcm80211 driver is currently a staging driver and as such maintained by
> GregKH

Oh, you are right. I only looked at the brcm80211 entry in
MAINTAINERS, which did no mention of both.

> (git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git). In
> the staging-next branch of that repository similar patches have already been
> posted. Maybe they are still in the queue.

The last commit I could found in staging-2.6.git was from December
16th, so I thought I was safe, but appearently I wasn't. (I also
didn't see that there was a separate ML for staging drivers). Thanks
for the head-up.

So please ignore this patch series ;-).

Regards,
Jonas Gorski
