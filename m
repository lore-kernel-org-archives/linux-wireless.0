Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59184 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1AEKc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 05:32:27 -0500
Received: by wwa36 with SMTP id 36so16125114wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 02:32:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
	<AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
	<AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
Date: Wed, 5 Jan 2011 11:32:25 +0100
Message-ID: <AANLkTimdEcj4k09ZyHQTXnbaeNj4CCrAm=mRTw+R5j6L@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Wolfgang Kufner <wolfgang.kufner@gmail.com>
To: Aleksandar Milivojevic <alex@milivojevic.org>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aleksandar,

On Wed, Jan 5, 2011 at 7:57 AM, Aleksandar Milivojevic
<alex@milivojevic.org> wrote:
> On Tue, Jan 4, 2011 at 2:31 PM, Wolfgang Kufner
> <wolfgang.kufner@gmail.com> wrote:
>> Maybe a fix for this issue is already in compat-wireless.
>
> Might be.  I'll try compiling linux-next and see if it helps (could be
> few days, I need to setup this box for the task first).
>

There is no need to compile linux-next. Just compile the latest
bleeding edge compat-wireless tarball from
http://wireless.kernel.org/en/users/Download. It is only 4MB in size
and reflects the latest on the linux-next.git tree and takes only a
few minutes to compile.

HTH,
Wolfgang
