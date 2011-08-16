Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47179 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1HPFVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 01:21:46 -0400
Received: by iye16 with SMTP id 16so8885140iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 22:21:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 16 Aug 2011 15:21:25 +1000
Message-ID: <CAGRGNgWrFbXNyhxhzsr48rLPSN-HwbSD0dr5amCQquCcs5zDcQ@mail.gmail.com> (sfid-20110816_072149_694830_0B1838E2)
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
To: Lin Tony-B19295 <B19295@freescale.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony,

One small point

On Tue, Aug 16, 2011 at 14:59, Lin Tony-B19295 <B19295@freescale.com> wrote:
>        Does it support master mode? I tried the driver, seems it doesn't. need your confirmation.
>                root@freescale ~$ iwconfig wlan0 mode master
>                Error for wireless request "Set Mode" (8B06) :
>                SET failed on device wlan0 ; Invalid argument.

This is _not_ how you enable master mode.

You need to use the hostapd utility.

See:

http://wireless.kernel.org/en/users/Documentation/FAQ#Q:_iwconfig_wlan0_mode_master_does_not_work

http://wireless.kernel.org/en/users/Documentation/hostapd

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
