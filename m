Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50307 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1CHFUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 00:20:32 -0500
Received: by wwa36 with SMTP id 36so488914wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 21:20:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimVS6sBqMKHT841QWwgz93DURM5rUWcFXKXRHYo@mail.gmail.com>
References: <AANLkTikYfE1pJfqcNcFT-SFQaAL2z91dpD1+8rOUZHr2@mail.gmail.com>
	<AANLkTim+ZL6xG=rK6zg5Chrgdno3vuRB4x8TbZsrJv_f@mail.gmail.com>
	<AANLkTimVS6sBqMKHT841QWwgz93DURM5rUWcFXKXRHYo@mail.gmail.com>
Date: Tue, 8 Mar 2011 10:50:31 +0530
Message-ID: <AANLkTi=sKKJ85nVzopsmnXW18hfjg+LZTy+2EBcqRE_r@mail.gmail.com>
Subject: Re: WMM and 802.11n Qurery, please help!
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "M. A." <jdiq123@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 8, 2011 at 2:39 AM, M. A. <jdiq123@googlemail.com> wrote:
> Dear all,
>
> Just an update to my previous query regarding the relation between WMM
> and 802.11n:
>
> Now from what I understand, WMM (802.11e) is part of the 802.11n
> standard as it uses features (like block-Ack) in the new (MAC layer)
> enhancements such as frame aggregation.
>
> When WMM is activated (via hostapd: wmm_enabled=1)  as well as frame
> aggregation, I get around 230Mbps UDP/ 170Mbps TCP. When WMM is
> deactivated I get 35  Mbps UDP and 27 Mbps TCP.
>
> I tried to identify the causes of this decrease, so I disabled frame
> Aggregation (A-MPDU) and disabled all the WMM associated parameters
> like tx_queue_data* , wmm_ac_* (BK/BE/VI/VO) /(CW/TXOP/AIFS) etc. but
> leaving the WMM option on (wmm_enabled=1). This gave around 45 Mbps
> UDP and 33Mbps TCP.

Hi,
  please read through the discussion in this thread "Why is wmm_param
required for HT40- in mlme.c" in linux wireless mailing list

>
>
> So my question is what other WMM influencing factor is activated that
> is causing the remaining throughput increase from 35 Mbps to 45 Mbps.
> Also if someone could explain the WMM traffic identifier's (TID)
> relevance in throughput improvement.
>
> Thank you all very much
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
