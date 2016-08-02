Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37515 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbcHBTD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 15:03:56 -0400
Received: by mail-wm0-f46.google.com with SMTP id i5so303991178wmg.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 12:02:41 -0700 (PDT)
Subject: Re: [PATCH 0768/1285] Replace numeric parameter like 0444 with macro
To: Kalle Valo <kvalo@codeaurora.org>, Baole Ni <baolex.ni@intel.com>
References: <20160802114428.860-1-baolex.ni@intel.com>
 <87k2fz5a9c.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e23f7be7-95f7-18b3-a650-d666d1ef852e@broadcom.com> (sfid-20160802_210416_167865_3CD4AE19)
Date: Tue, 2 Aug 2016 20:34:33 +0200
MIME-Version: 1.0
In-Reply-To: <87k2fz5a9c.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02-08-16 19:52, Kalle Valo wrote:
> (Trimming CC)
> 
> Baole Ni <baolex.ni@intel.com> writes:
> 
>> I find that the developers often just specified the numeric value
>> when calling a macro which is defined with a parameter for access permission.
>> As we know, these numeric value for access permission have had the corresponding macro,
>> and that using macro can improve the robustness and readability of the code,
>> thus, I suggest replacing the numeric parameter with the macro.
>>
>> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
>> Signed-off-by: Baole Ni <baolex.ni@intel.com>
>> ---
>>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Over 1000 patches? It's totally inapproriate to spam people's inboxes
> (including mine) like this. PLEASE first study how kernel development
> works and then start with something small, not like this.
> 
> I'm dropping all patches from this patchset.

And this type of change has been tried before and burned by Linus as
everybody with a bit of *nix background knows the meaning of the
numerical access permissions.

Regards,
Arend
