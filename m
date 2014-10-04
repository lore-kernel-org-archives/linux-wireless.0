Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37775 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaJDBG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 21:06:28 -0400
Received: by mail-vc0-f169.google.com with SMTP id hy4so1407263vcb.0
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2014 18:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Sat, 4 Oct 2014 09:06:27 +0800
Message-ID: <CAEFj985Di47A3OUSKn3ycW01Ohmeqs=uL4y_59YL+HyUDWvO0g@mail.gmail.com> (sfid-20141004_030633_513336_C88F2B9C)
Subject: Re: [PATCH] ath10k: don't create bssid peer for ibss
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 2, 2014 at 7:56 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> It's not really necessary to create bssid peer for
> bssid. Self-address peer is sufficient.
>
> This prevents some firmware revisions from crashing.
>

Which firmware? AFAIK, only firmware version 636 supports adhoc, right?

---
Chun-Yeow
