Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:33055 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbcB2XqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:46:24 -0500
Received: by mail-ig0-f194.google.com with SMTP id hb3so701366igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 15:46:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> <1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 10:46:04 +1100
Message-ID: <CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com> (sfid-20160301_004637_239087_9296373F)
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> rtl8723bu_init_bt() is effectively the function enabling RF, so name
> it appropriately.

Should this be merged into the patches that introduce these functions?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
