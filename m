Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:60329 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYH1Mnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:43:55 -0400
Received: by ey-out-2122.google.com with SMTP id 6so106228eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 05:43:54 -0700 (PDT)
Message-ID: <1ba2fa240808280543qbcb769n74fc8fa733d951a2@mail.gmail.com> (sfid-20080828_144414_963990_80D07298)
Date: Thu, 28 Aug 2008 15:43:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
	"Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219926182.25321.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com>
	 <1219926182.25321.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-08-28 at 14:21 +0300, Tomas Winkler wrote:
>> On Thu, Aug 28, 2008 at 3:33 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> > Hi Yi,
>> >
>> >> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
>> >> cleared which disabled moving device to D0U state.
>> >
>> > when was this mistake introduced. Is it a regression compared to what we
>> > have in 2.6.26?
>>
>> Again. think of global warming.
>
> If you're so concerned about global warming, why didn't you fix this,
> umm, months ago? :)

Why I didn't fix everything in the single point of time. 'In the
beginning there was a driver'
>
> Frankly, this sounds like a "quick, somebody help me come up with a good
> argument" argument.

So how can I really reason this :)
Tomas
