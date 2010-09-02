Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21575 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0IBIhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:37:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 01:37:13 -0700
Date: Thu, 2 Sep 2010 14:07:09 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: Implement an algorithm for Antenna
	diversity and combining
Message-ID: <20100902083709.GF3780@vasanth-laptop>
References: <1283416483-5674-1-git-send-email-vasanth@atheros.com> <1283416483-5674-3-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1283416483-5674-3-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 02, 2010 at 02:04:43PM +0530, Vasanthakumar Thiagarajan wrote:
> This algorithm chooses the best main and alt lna out of
> LNA1, LNA2, LNA1+LNA2 and LNA1-LNA2 to improve rx for single
> chain chips(AR9285). This would greatly improve rx when there
> is only one antenna is connected with AR9285.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |   56 ++++
>  drivers/net/wireless/ath/ath9k/init.c  |    3 +
>  drivers/net/wireless/ath/ath9k/recv.c  |  545 ++++++++++++++++++++++++++++++++
>  3 files changed, 604 insertions(+), 0 deletions(-)
> 


These patches are V2, sorry forgot to mention.

Vasanth
