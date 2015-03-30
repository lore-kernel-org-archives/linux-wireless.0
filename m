Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35550 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbbC3SRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 14:17:52 -0400
Received: by obcjt1 with SMTP id jt1so132424866obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 11:17:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ego64nny.fsf@kamboji.qca.qualcomm.com>
References: <1427476680-5532-1-git-send-email-yanbol@qca.qualcomm.com>
	<87ego64nny.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 30 Mar 2015 11:17:51 -0700
Message-ID: <CAFuUQkhKrU0VDki49VLYoeppXJZXxU--v0kykfgUGZSr_ywgwA@mail.gmail.com> (sfid-20150330_201755_406081_727CBF7B)
Subject: Re: [PATCH] ath10k: Change the fw stats access mask
From: YanBo <dreamfly281@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Yanbo Li <yanbol@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2015 at 6:31 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Yanbo Li <yanbol@qca.qualcomm.com> writes:
>
>> This fix the regerssion introduced after "ath10k_wmi_requests_stats()
>> call to use more stat bits", both the 10.2.X FW and community FW 10.1.X
>> will return time out when access the fw_stats with the STAT_VDEV and
>> STAT_PDEV. Add the condition to use different fw_stats mask for different
>> FW versions.
>>
>> Fixes:7777d8c7ef6f("ath10k: implement fw stats for wmi-tlv")
>> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
>
> There was a trivial conflict, please check my resolution in the pending
> branch.
>
Checked, looks well,  Thanks

BR /Yanbo
