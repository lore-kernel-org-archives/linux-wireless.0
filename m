Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50791 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757262Ab0JAPHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 11:07:46 -0400
Date: Fri, 1 Oct 2010 08:07:38 -0700
From: Jouni Malinen <j@w1.fi>
To: Mohammed Shafi Shajakhan <mshajakhan@Atheros.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	Senthilkumar.Balasubramanian@Atheros.com,
	Vasanth.Thiagarajan@Atheros.com, nbd@openwrt.org
Subject: Re: [RFC] ath9k : Fix for displaying the channel number
Message-ID: <20101001150738.GA9599@jm.kir.nu>
References: <1285840208-12456-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285840208-12456-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 03:20:08PM +0530, Mohammed Shafi Shajakhan wrote:
> In the ath9k debugging feature 'wiphy' the current channel used by the
> station is incorrectly displayed.This is because the channels available
> are sequentially mapped from numbers 0 to 37.This mapping cannot be
> changed as the channel number is also used as an array index

This is a debug output and meant for developers.. Changing it to
something else than the internal index makes it more difficult to use
for what it was intended for.

-- 
Jouni Malinen                                            PGP id EFC895FA
