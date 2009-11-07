Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:55143 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZKGUXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:23:40 -0500
Received: by iwn10 with SMTP id 10so1588760iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 12:23:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 7 Nov 2009 12:23:25 -0800
Message-ID: <43e72e890911071223k5419da67h165056d9ca011c63@mail.gmail.com>
Subject: Re: [PATCH 00/29] ath: virtual wiphy updates / add ath9k_common
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2009 at 12:18 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> The first set of patches are the virtual wiphy updates which I had
> sent out as RFTs, I've not tested them.

I meant I have now tested them of course. Keep in mind though I'm now
certain the virtual wiphy implementation on ath9k needs some
re-thinking in light of handling the vif which would have to either be
book-kept on ath9k itself for each wiphy or we'd have to do some
complex search on ath9k for a few wiphys.

  Luis
