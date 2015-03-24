Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38417 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbCXHd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 03:33:29 -0400
Received: by igbqf9 with SMTP id qf9so59488008igb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 00:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87pp7zd81d.fsf@kamboji.qca.qualcomm.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com>
	<87pp7zd81d.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 24 Mar 2015 03:33:28 -0400
Message-ID: <CADnKcVizKNOJwhc9a=XfPUZfEM3V+QJ59sK0oorWK-b3jeKRyA@mail.gmail.com> (sfid-20150324_083333_744825_88862057)
Subject: Re: [PATCH v4 5/6] ath10k: add wmi support for tdls
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2015 at 11:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Marek Puzyniak <marek.puzyniak@tieto.com> writes:
>
>> As a part of tdls implementation introduce
>> tdls related wmi data structures, constant
>> values and functions.
>>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>
> This patch had non-trivial conflicts, please check carefully my
> resolution in the pending branch.
>
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
>
> --
> Kalle Valo

It looks OK, but there is one small thing in file
drivers/net/wireless/ath/ath10k/wmi-tlv.c.
There are two new lines between functions ath10k_wmi_tlv_op_gen_tdls_peer_update
and ath10k_wmi_tlv_op_gen_wow_enable.

Thanks,
Marek
