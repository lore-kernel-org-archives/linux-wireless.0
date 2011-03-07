Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33418 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1CGVJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 16:09:28 -0500
Received: by wyg36 with SMTP id 36so4589360wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 13:09:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim+ZL6xG=rK6zg5Chrgdno3vuRB4x8TbZsrJv_f@mail.gmail.com>
References: <AANLkTikYfE1pJfqcNcFT-SFQaAL2z91dpD1+8rOUZHr2@mail.gmail.com>
	<AANLkTim+ZL6xG=rK6zg5Chrgdno3vuRB4x8TbZsrJv_f@mail.gmail.com>
Date: Mon, 7 Mar 2011 21:09:26 +0000
Message-ID: <AANLkTimVS6sBqMKHT841QWwgz93DURM5rUWcFXKXRHYo@mail.gmail.com>
Subject: Re: WMM and 802.11n Qurery, please help!
From: "M. A." <jdiq123@googlemail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

Just an update to my previous query regarding the relation between WMM
and 802.11n:

Now from what I understand, WMM (802.11e) is part of the 802.11n
standard as it uses features (like block-Ack) in the new (MAC layer)
enhancements such as frame aggregation.

When WMM is activated (via hostapd: wmm_enabled=1)  as well as frame
aggregation, I get around 230Mbps UDP/ 170Mbps TCP. When WMM is
deactivated I get 35  Mbps UDP and 27 Mbps TCP.

I tried to identify the causes of this decrease, so I disabled frame
Aggregation (A-MPDU) and disabled all the WMM associated parameters
like tx_queue_data* , wmm_ac_* (BK/BE/VI/VO) /(CW/TXOP/AIFS) etc. but
leaving the WMM option on (wmm_enabled=1). This gave around 45 Mbps
UDP and 33Mbps TCP.


So my question is what other WMM influencing factor is activated that
is causing the remaining throughput increase from 35 Mbps to 45 Mbps.
Also if someone could explain the WMM traffic identifier's (TID)
relevance in throughput improvement.

Thank you all very much
