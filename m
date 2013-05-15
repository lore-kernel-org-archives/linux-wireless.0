Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897Ab3EOPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 11:01:39 -0400
Message-ID: <1368630093.20897.8.camel@jlt4.sipsolutions.net> (sfid-20130515_170142_644397_0B3A22F1)
Subject: Re: [PATCH 02/29] ath10k: add bmi.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 17:01:33 +0200
In-Reply-To: <20130515144254.4492.14914.stgit@localhost6.localdomain6> (sfid-20130515_165258_187588_0CE3CF23)
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
	 <20130515144254.4492.14914.stgit@localhost6.localdomain6>
	 (sfid-20130515_165258_187588_0CE3CF23)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-15 at 17:42 +0300, Kalle Valo wrote:

> +/*
> + * Bootloader Messaging Interface (BMI)

This looks exactly like ath6kl, but is it? Seems it might have potential
for sharing the code.

johannes

