Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:58401 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaCNLit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 07:38:49 -0400
Received: by mail-la0-f41.google.com with SMTP id gl10so1673735lab.14
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 04:38:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnx983oh.fsf@kamboji.qca.qualcomm.com>
References: <20140313082431.10798.10888.stgit@potku.adurom.net>
	<87bnx983oh.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 14 Mar 2014 12:38:48 +0100
Message-ID: <CADnKcVjjpes6uMM8pwwPKrqLfduYYYRvh2EAW4D2_RWv4zxDRA@mail.gmail.com> (sfid-20140314_123853_565780_67FCD080)
Subject: Re: [PATCH v2] ath10k: add soft/hard firmware crash option to simulate_fw_crash
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 14 March 2014 11:39, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Hi Marek,
>
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> From: Marek Puzyniak <marek.puzyniak@tieto.com>
>>
>> Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
>> In order to have firmware crash simulation functionality also
>> in firmware 10.1 driver can force firmware crash by performing not allowed
>> operation. Driver can deliberately crash firmware when setting vdev param for
>> vdev id out of range.  This patch introduces two keywords to simulate_fw_crash:

[...]

> can you please review my changes and check if they are ok?

Looks fine.

Thank you,
Marek
