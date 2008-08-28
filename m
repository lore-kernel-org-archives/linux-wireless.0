Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:50381 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYH1Liq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:38:46 -0400
Received: by ey-out-2122.google.com with SMTP id 6so99785eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:38:44 -0700 (PDT)
Message-ID: <1ba2fa240808280438o7c5c9b38y7b2572fbe222ed5f@mail.gmail.com> (sfid-20080828_133850_251524_042D4BA0)
Date: Thu, 28 Aug 2008 14:38:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive channels
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Cahill Ben" <ben.m.cahill@intel.com>
In-Reply-To: <1219927771.6064.39.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219926558.6064.11.camel@californication>
	 <1ba2fa240808280340o216da98dwbf84541aa7bfd2e6@mail.gmail.com>
	 <1219927771.6064.39.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:49 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Thomas,
>
>> >> This patch gives the HW the possibility to send direct probes in passive
>> >> channels (as long as traffic was detected in that channel) if such ssid
>> >> was requested, so hidden ssid can be found now in those channels as well.
>> >
>> > this also doesn't sound like a regression to me. Nice to have for sure,
>> > but not acceptable according to the merge window rules.
>>
>> If you cannot scan your AP you also not able to connect to it, drawing
>> your card useless.
>>
>> > Question here is was the driver supporting this before and we broke it
>> > in the 2.6.27 phase or not.
>>
>> Irrelevant, this is fixing show stopper bug.
>
> it is relevant. So I read this commit message as, that now we can also
> find hidden SSIDs in passive channels. Question that you should ask then
> is if that was supported before. Yes or no. If yes, then it is a
> regression, no then it is a feature. And regression fixes go in features
> wait for the next merge window.
>
> The term show stopper bug is irrelevant when it comes to merge window
> rules.
>
I don't know if it worked before or not I didn't check. This is new code.
Tomas
