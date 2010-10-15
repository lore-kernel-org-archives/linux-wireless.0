Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55564 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0JOH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 03:57:41 -0400
Message-ID: <4CB80969.5040902@openwrt.org>
Date: Fri, 15 Oct 2010 09:57:29 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath9k_hw: avoid division-by-zero in ani
References: <alpine.DEB.2.00.1010150150110.20478@bigbill>
In-Reply-To: <alpine.DEB.2.00.1010150150110.20478@bigbill>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-15 2:00 AM, Björn Smedman wrote:
> The ath9k ANI code may under some circumstances do division-by-zero. This 
> patch detects and avoids that case.
Should be obsolete with my patch from 3 days ago:
[PATCH 1/3] ath9k_hw: fix division by zero in the ANI monitor code

- Felix
