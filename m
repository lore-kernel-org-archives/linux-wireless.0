Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45772 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaEIAVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 20:21:22 -0400
Received: by mail-oa0-f44.google.com with SMTP id i11so4062772oag.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 17:21:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398125395-5579-1-git-send-email-notasas@gmail.com>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
Date: Fri, 9 May 2014 03:21:21 +0300
Message-ID: <CANOLnOO0xPH9kfZuqdbpYkdQrOFAOvL-4H0QmfAUVKCwg0ot2Q@mail.gmail.com> (sfid-20140509_022126_818267_DD6AAD96)
Subject: Re: [PATCH 0/4] wl1251 IBSS fixes
From: Grazvydas Ignotas <notasas@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 3:09 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> IBSS mode is currently advertised by wl1251 driver but is totally broken.
> First there is a disconnect hack for monitor mode that was recently merged,
> it abuses mac80211 and causes corruption in IBSS mode, so I think should be
> reverted. Then there are several cases of station-only mac80211 functions
> called carelessly, what is also fixed.

Ping.
This driver is orphan and hardware carrying it is outdated, so acks /
tested-bys are unlikely..


-- 
Gražvydas
