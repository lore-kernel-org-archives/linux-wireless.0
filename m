Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47989 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1IZVGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:06:42 -0400
Received: by yib18 with SMTP id 18so4595161yib.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 14:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316830148-28661-10-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
	<1316830148-28661-10-git-send-email-frankyl@broadcom.com>
Date: Mon, 26 Sep 2011 23:06:41 +0200
Message-ID: <CACna6rzWVxDvRTFGPwG+c4a+YrpsCPoXBZc80G2Wvbt8ebpb9Q@mail.gmail.com> (sfid-20110926_230658_741993_A3D053D5)
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated structures
 in brcmsmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/24 Franky Lin <frankyl@broadcom.com>:
> @@ -1392,20 +1407,21 @@ struct d11rxhdr {
>        u16 RxStatus2;
>        u16 RxTSFTime;
>        u16 RxChan;
> -} __packed;
> +};

Is this on purpose? Is this safe?

-- 
Rafał
