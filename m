Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:33065 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757389AbcG1MFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 08:05:07 -0400
Subject: Re: [RFC v0 4/8] Input: goodix: use firmware_stat instead of
 completion
To: Bastien Nocera <hadess@hadess.net>, Daniel Wagner <wagi@monom.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-5-git-send-email-wagi@monom.org>
 <1469704952.6761.142.camel@hadess.net>
CC: <linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<irina.tirdea@intel.com>, <octavian.purdila@intel.com>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <f7dd0db5-af15-7310-ac9f-1034bdf4f592@bmw-carit.de> (sfid-20160728_140527_717807_248E56A7)
Date: Thu, 28 Jul 2016 13:59:00 +0200
MIME-Version: 1.0
In-Reply-To: <1469704952.6761.142.camel@hadess.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2016 01:22 PM, Bastien Nocera wrote:
> On Thu, 2016-07-28 at 09:55 +0200, Daniel Wagner wrote:
>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>
>> Loading firmware is an operation many drivers implement in various
>> ways
>> around the completion API. And most of them do it almost in the same
>> way. Let's reuse the firmware_stat API which is used also by the
>> firmware_class loader. Apart of streamlining the firmware loading
>> states
>> we also document it slightly better.
>>
>> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
>
> Irina added and tested that feature, so best for her to comment on
> this, as I don't have any hardware that would use this feature.

In case you have any comments on the API, let me know. I'll add Irina to 
the Cc list in the next version.

cheers,
daniel

