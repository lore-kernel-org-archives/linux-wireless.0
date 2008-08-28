Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:57810 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYH1Oii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:38:38 -0400
Received: by nf-out-0910.google.com with SMTP id d3so69457nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 07:38:37 -0700 (PDT)
Message-ID: <1ba2fa240808280738v17024954wcd4b77be0e2c1238@mail.gmail.com> (sfid-20080828_163841_123832_B4D3EFDC)
Date: Thu, 28 Aug 2008 17:38:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 09/11] iwlwifi: fix station mimo power save values
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1219932128.6064.57.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-10-git-send-email-yi.zhu@intel.com>
	 <1219927236.6064.27.camel@californication>
	 <1ba2fa240808280411l4b229cfdnbcb24b3ad5cae1cd@mail.gmail.com>
	 <1219932128.6064.57.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 5:02 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> >> This patch fixes the wrong use of self mimo power save values instead of
>> >> peer's mimo power save values.
>> >
>> > please state the impact of not fixing this. When does this matter. Does
>> > the both sides have to enable this feature and things like this.
>>
>> Okay, we might not be able to do any traffic to the [peer station
>> because by mistake we configured TX to according our RX capability not
>> RX capability of the peer station.
>
> that would have been a good addition to the commit message. That the
> result of this issue is no TX, belongs in it.

But isn't it stating obvious.
Tomas
>
