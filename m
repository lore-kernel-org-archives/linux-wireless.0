Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47674 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0JAVi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:38:26 -0400
Received: by yxp4 with SMTP id 4so1304211yxp.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 14:38:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+a01++8ZDt3D5KVrvapBrAM0AfGF=TOxxzOEe@mail.gmail.com>
References: <201009282301.00027.chunkeey@googlemail.com> <AANLkTi=+a01++8ZDt3D5KVrvapBrAM0AfGF=TOxxzOEe@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 14:38:05 -0700
Message-ID: <AANLkTimH_vuVD7byRS-h3KPEbxwYYgiRa02684nSG0B6@mail.gmail.com>
Subject: Re: [PATCH] carl9170: support firmware-based rx filter
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 2:32 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Sep 28, 2010 at 2:00 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>> The hardware rx-filter was essentially disabled, because
>> of a serve, yet unidentifiable problem with iwlagn.
>> Due to these circumstances the driver and mac80211 were
>> left with the job of filtering.
>>
>> This is very unfortunate and has proven to be expensive
>> in terms of latency, memory and load.
>>
>> Therefore the new 1.8.8.3 firmware introduces a flexible
>> filtering infrastructure which allows the driver to
>> offload some of the checks (FCS & PLCP crc check,
>> RA match, control frame filter, etc...) whenever possible.
>>
>> Note:
>> This patch also includes all changes to the
>> shared headers files since the inclusion.
>>
>> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
>
> I'm sucking this into compat-wireless into linux-next-pending/

John, any chance this will make it for 37?

  Luis
