Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37216 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0JFJyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:54:38 -0400
Received: by iwn5 with SMTP id 5so9540207iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 02:54:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101005095526.3083.82322.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk>
	<20101005095526.3083.82322.stgit@tt-desk>
Date: Wed, 6 Oct 2010 11:54:37 +0200
Message-ID: <AANLkTimpPuwDFUidUprBkLoJrpr=5tnwCcNcnHmfT_Z7@mail.gmail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 11:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> This adds three new values to the survey results:
>
>  * BUSY - percentage of time the channel was busy
>  * BUSY_TX - percentage of time spent transmitting frames
>  * BUSY_RX - percentage of time spent receiving frames

Does BUSY include BUSY_RX and BUSY_TX already? At least on
rt2800 devices we only have access to BUSY which already includes
BUSY_RX and TX.

And what about BUSY on the secondary channel in case of 40Mhz?

Thanks,
Helmut
