Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:44430 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3H0IjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:39:23 -0400
Received: by mail-la0-f43.google.com with SMTP id ep20so3219101lab.16
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 01:39:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87txibmxk0.fsf@kamboji.qca.qualcomm.com>
References: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
	<87txibmxk0.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 27 Aug 2013 10:39:22 +0200
Message-ID: <CACKGw+HRdWxi-+t7rY_uuKhiDFJZ8sytNTEC=Be1vNQKOKNGeQ@mail.gmail.com> (sfid-20130827_103927_779664_A9EA1405)
Subject: Re: [PATCH 0/3] ath10k: initial per-VDEV FW statistics implementation
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2013 08:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> FW 1.0.0.716 brings per-VDEV statistics. This patch-set implements
>> debugfs mechanism to fetch those. There's still few more fileds we
>> can read from the FW stats event, which are not covered here.
>>
>> Please note there's an ABI change in wmi_peer_stats structure, hence
>> the PEER statistics will be corrupted if used with older firmware
>> (e.g. 1.0.0.636)
>
> We need to support the older firmware, so please add a feature flag VDEV
> statistics so that we can detect which version of the struct needs to be
> used.
>
> Also I think you can fold patches 1 and 2.

OK, will do. Please drop this patch-set and I will send a single one.

-- 
Bartosz
