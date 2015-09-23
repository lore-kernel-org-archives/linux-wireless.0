Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbbIWFIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 01:08:12 -0400
Message-ID: <5602339F.1010301@linux.intel.com> (sfid-20150923_070836_603276_E2BC8441)
Date: Wed, 23 Sep 2015 13:07:43 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/wireless: enable wiphy device to suspend/resume
 asynchronously
References: <55FCCB0E.3000807@linux.intel.com> <1442930747.2018.12.camel@sipsolutions.net>
In-Reply-To: <1442930747.2018.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi johannes,

Could you please tell me which kernel version will merge this patch?


Thanks,
Zhonghui

 
On 2015/9/22 22:05, Johannes Berg wrote:
> On Sat, 2015-09-19 at 10:40 +0800, Fu, Zhonghui wrote:
>> Now, PM core supports asynchronous suspend/resume mode for devices
>> during system suspend/resume, and the power state transition of one
>> device may be completed in separate kernel thread. PM core ensures
>> all power state transition timing dependency between devices. This
>> patch enables wiphy device to suspend/resume asynchronously. This can
>> take advantage of multicore and improve system suspend/resume speed.
>>
> Applied.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

