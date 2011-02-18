Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55680 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab1BRSEr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 13:04:47 -0500
Message-ID: <4D5EB4BC.5030009@openwrt.org>
Date: Fri, 18 Feb 2011 19:04:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k correct interrupts ?
References: <20110218125955.GA4209@redhat.com>
In-Reply-To: <20110218125955.GA4209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-18 2:00 PM, Stanislaw Gruszka wrote:
> I'm not sure if that patch is correct or not. It possibly fix
> change from commit 4df3071ebd92ef7115b409da64d0eb405d24a631
> "ath9k_hw: optimize interrupt mask changes" that looks
> suspicious for me. But from other hand this patch
> could be totally wrong. Felix?
Looks good to me

- Felix
