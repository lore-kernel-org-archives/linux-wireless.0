Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35017 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565AbcCPX20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 19:28:26 -0400
Received: by mail-ob0-f172.google.com with SMTP id fp4so67114393obb.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 16:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56A5F060.6050306@broadcom.com>
References: <1453295190-28404-1-git-send-email-zajec5@gmail.com> <56A5F060.6050306@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Mar 2016 10:28:05 +1100
Message-ID: <CAGRGNgWjqWCD4JQME9FE3D2jwvwqPT6K-gayEnUtmdpvnMUEpQ@mail.gmail.com> (sfid-20160317_002829_622944_8FF2FC97)
Subject: Re: [PATCH] brcmfmac: advertise frames supported for TX in AP mode
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jan 25, 2016 at 8:52 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
>
> On 20-1-2016 14:06, Rafał Miłecki wrote:
>> Callback mgmt_tx implementation supports both: PROBE_RESP and ACTION.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> This matches code I can see in brcmf_cfg80211_mgmt_tx, hope it makes
>> sense.
>
> As said in another response [1] this function was added for P2P
> functionality. Hence I do not feel comfortable adding this patch without
> subsequent testing.

Has anyone tested this yet?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
