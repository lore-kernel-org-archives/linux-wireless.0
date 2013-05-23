Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab3EWVj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 17:39:26 -0400
Message-ID: <1369345157.12002.87.camel@jlt4.sipsolutions.net> (sfid-20130523_233929_252262_60C750E6)
Subject: Re: [PATCH v2 1/2] iw: use updated structures and enums for packet
 pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 23 May 2013 23:39:17 +0200
In-Reply-To: <1369344941-11217-1-git-send-email-bzhao@marvell.com>
References: <1369344941-11217-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 14:35 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> They are renamed so that they can be used for new feature.

This isn't really necessary, right? I mean, it should compile w/o this
even after the kernel patches, but this is just for making it look
nicer?

johannes

