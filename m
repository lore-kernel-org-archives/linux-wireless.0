Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:63468 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXJPQIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 12:08:32 -0400
Received: by an-out-0708.google.com with SMTP id d31so219992and
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 09:08:31 -0700 (PDT)
Message-ID: <43e72e890710160908y68505c18y5e78b1647f0bd067@mail.gmail.com> (sfid-20071016_170835_846904_CB1FC2DB)
Date: Tue, 16 Oct 2007 12:08:31 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/3] ath5k global rename of hal to hw
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1192540838-26985-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/07, Bruno Randolf <bruno@thinktube.com> wrote:
> i don't want to see that dreaded HAL word again ;)
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Thanks for this. If its not too much trouble can you rename hal to
"ah" instead? I was going to use hw too but the fact of the matter is
that in mac80211 we use "hw" to refer to the struct ieee80211_hw so
using "hw" for the ath_hw struct may be confusing at times. The "ah"
notion is also used throughout the driver in other cases as well.

  Luis
