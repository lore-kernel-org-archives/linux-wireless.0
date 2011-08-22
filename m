Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39976 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HVPDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:03:15 -0400
Received: by yie30 with SMTP id 30so3627786yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 08:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313501082-10786-2-git-send-email-hauke@hauke-m.de>
References: <1313501082-10786-1-git-send-email-hauke@hauke-m.de> <1313501082-10786-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Aug 2011 08:02:55 -0700
Message-ID: <CAB=NE6UdD+7doBnDD5NSzj1W92Fzs6xRoffL+HC1KnoooSPpaQ@mail.gmail.com> (sfid-20110822_170318_012468_2A2C3908)
Subject: Re: [PATCH 2/2] compat-wireless: add many fixes to driver-select
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 6:24 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> after driver-select was used it built often not needed modules. This is
> now fixed for most options. Most of these problems where introduced
> while a new driver was added to compat-wireless, but driver-select was
> not updated.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

both applied, thanks!!


 Luis
