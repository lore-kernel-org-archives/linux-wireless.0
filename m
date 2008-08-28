Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:42877 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYH1KkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:40:23 -0400
Received: by ey-out-2122.google.com with SMTP id 6so94082eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 03:40:21 -0700 (PDT)
Message-ID: <1ba2fa240808280340o216da98dwbf84541aa7bfd2e6@mail.gmail.com> (sfid-20080828_124026_367459_1C4B24C5)
Date: Thu, 28 Aug 2008 13:40:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive channels
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Cahill Ben" <ben.m.cahill@intel.com>
In-Reply-To: <1219926558.6064.11.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219926558.6064.11.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:29 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Yi,
>
>> This patch gives the HW the possibility to send direct probes in passive
>> channels (as long as traffic was detected in that channel) if such ssid
>> was requested, so hidden ssid can be found now in those channels as well.
>
> this also doesn't sound like a regression to me. Nice to have for sure,
> but not acceptable according to the merge window rules.

If you cannot scan your AP you also not able to connect to it, drawing
your card useless.

> Question here is was the driver supporting this before and we broke it
> in the 2.6.27 phase or not.

Irrelevant, this is fixing show stopper bug.

Tomas
