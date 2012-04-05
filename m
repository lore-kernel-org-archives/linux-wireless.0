Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37366 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2DEGvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 02:51:44 -0400
Received: by vbbff1 with SMTP id ff1so815394vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 23:51:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333607947.27729.70.camel@cumari>
References: <CAHPDcRuZyS_ibSBGgzDvREHcVCQOw=roia1RRrJUU3TtQOYGSA@mail.gmail.com>
	<1333607947.27729.70.camel@cumari>
Date: Thu, 5 Apr 2012 14:51:43 +0800
Message-ID: <CAHPDcRt3rqq4qcfSjMEq9=5AnM6rdXNAgsZPfrhxkVcoEgxZmQ@mail.gmail.com> (sfid-20120405_085147_674418_19C86666)
Subject: Re: wl1271 acx bet
From: Yingang Fu <yingang.fu@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, Luca


Thank you very much.

Yingang

在 2012年4月5日 下午2:39，Luciano Coelho <coelho@ti.com> 写道：
> On Thu, 2012-04-05 at 11:41 +0800, Yingang Fu wrote:
>> hi, all
>
> Hi Yingang,
>
>
>> Does anybody could help me out of the meaning/function of the wl1271 acx bet?
>
> BET means Beacon Early Termination.  What it does is to stop processing
> a beacon when it realizes that there are not frames advertised by the AP
> (and thus, the beacon is not useful to us).  This helps minimize power
> consumption in PS mode.
>
> --
> Cheers,
> Luca.
>
