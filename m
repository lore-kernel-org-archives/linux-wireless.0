Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34840 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879AbaGIP3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 11:29:37 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21437.22159.76409.186487@gargle.gargle.HOWL> (sfid-20140709_172944_797999_7CADF42B)
Date: Wed, 9 Jul 2014 20:19:51 +0530
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC 03/10] ath9k: add dynamic ack timeout estimation
In-Reply-To: <1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi wrote:
> +/*
> + * Copyright 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

I have not reviewed the patches, but the ath9k driver is licensed
under ISC. Introducing a file with GPLv2 license is bound to cause
complications and I think might require legal clearance from a
QCA employee maintaining ath9k.

Right now, I am not sure if there is an official maintainer for
ath9k, but is there any specific reason why you have chosen
GPLv2 ?

Sujith
