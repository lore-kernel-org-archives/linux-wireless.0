Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59549 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaJTJDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:03:06 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so6509096wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 02:03:05 -0700 (PDT)
Date: Mon, 20 Oct 2014 11:02:56 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] add VHT support to minstrel_ht
Message-ID: <20141020090256.GA11871@magnum.frso.rivierawaves.com> (sfid-20141020_110311_235531_860D9597)
References: <1413652424-14345-5-git-send-email-karl.beldan@gmail.com>
 <1413795342-11995-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413795342-11995-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix, I added your Acks in the patches but git-send-email did not send
them to the Acked-by addresses.
 
Karl

On Mon, Oct 20, 2014 at 10:55:38AM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Hi,
> 
> This is just a respin rebased on v2 of "mac80211: minstrels: fix buffer
> overflow in HT debugfs" which only affects 4/4.
> 
