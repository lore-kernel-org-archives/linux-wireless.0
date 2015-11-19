Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34007 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbbKSQVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 11:21:19 -0500
Received: by wmvv187 with SMTP id v187so33724974wmv.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 08:21:18 -0800 (PST)
Message-ID: <564DF6FB.8040706@gmail.com> (sfid-20151119_172126_878347_FE127158)
Date: Thu, 19 Nov 2015 17:21:15 +0100
From: ferran <ranker72@gmail.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [question] Rate control algorithm for mesh
References: <5649FE1F.4060203@gmail.com> <564A1D7F.6050201@openwrt.org>
In-Reply-To: <564A1D7F.6050201@openwrt.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16/11/15 19:16, Felix Fietkau wrote:
>
> Rate control instances are always per sta (so per 802.11 destination).
I totally ignored that.
> The problem you are describing either doesn't exist, or is something
> different from what you're describing.
> I would recommend running a test with latest mac80211 and minstrel(_ht),
> it should perform much better than PID.
>
> - Felix

In this case, I'll repeat the experiments with minstrel enabled. We have
already planned it.

Thank you a lot.
Ferran
