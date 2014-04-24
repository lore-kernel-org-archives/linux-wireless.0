Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61678 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaDXIuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:50:16 -0400
Received: by mail-vc0-f180.google.com with SMTP id hq16so85727vcb.11
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 01:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
Date: Thu, 24 Apr 2014 16:50:15 +0800
Message-ID: <CAEFj986fsmUD2kvEN=vjHK32cunyFO+8bH-y7ZoWZAMkcunJ2w@mail.gmail.com> (sfid-20140424_105022_647673_4648B190)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think Monitor operation should be performed on a best effort basis.
> This means monitor_start/stop should be attempted once number of
> non-monitor vdevs changes.

I am too clear about this. Do you mean that actually we can have
monitor mode on non-monitor vdevs in firmware 636?

----
Chun-Yeow
