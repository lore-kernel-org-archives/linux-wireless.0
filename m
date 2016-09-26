Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933368AbcIZKp4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 06:45:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        "Avinash Patil" <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        "Sergei Maksimenko" <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <87a8f68wae.fsf@kamboji.qca.qualcomm.com>
        <dfdaca87-dfbd-4677-fbff-45127ccd2e0c@quantenna.com>
Date: Mon, 26 Sep 2016 13:45:49 +0300
In-Reply-To: <dfdaca87-dfbd-4677-fbff-45127ccd2e0c@quantenna.com>
        (IgorMitsyanko's message of "Tue, 20 Sep 2016 22:05:07 +0300")
Message-ID: <87shsnym5e.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_124559_822206_5485A6E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> On 09/17/2016 04:56 PM, Kalle Valo wrote:
>> <igor.mitsyanko.os@quantenna.com> writes:
>>
>>> +/* FW names */
>>> +
>>> +#define QTN_PCI_FW_NAME		"pearl-linux.lzma.img"
>>
>> The firmware name gives no indication what this file is about (remember
>> that linux-firmware.git has a lot of files). Please name it properly,
>> don't just use what is used in by firmware build scripts :) Take into
>> account also future hw support, all firmware files need to coexist in
>> the same repository without user invention. In a way the firmware
>> filename is part of kernel/userspace interface and needs to be stable.
>>
>> For example, you could use something like "qtnfmac/qsr10g.img" (assuming
>> qsr10g is the name of chip).
>
> Ok, we will reconsider our naming conventions, take into account more
> devices that we need to support in the future.
> I'm thinking about something like:
> qtn/fmac_qsr10g.img  <---- FullMAC QSR10G device
> qtn/fmac_qsr1000.img  <---- FullMAC QSR1000 device
> qtn/smac_qsr10g.img  <---- SoftMAC QSR10G
> qtn/smac_qsr10000.img <----- SoftMAC QSR1000
> etc

Looks good to me.

-- 
Kalle Valo
