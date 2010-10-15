Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39619 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0JOIqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 04:46:06 -0400
Received: by iwn35 with SMTP id 35so664933iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 01:46:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB80969.5040902@openwrt.org>
References: <alpine.DEB.2.00.1010150150110.20478@bigbill>
	<4CB80969.5040902@openwrt.org>
Date: Fri, 15 Oct 2010 10:46:04 +0200
Message-ID: <AANLkTinLBZXTFN2khn=c4_mCed1WVKO30978fUs0th88@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: avoid division-by-zero in ani
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/15 Felix Fietkau <nbd@openwrt.org>:
> On 2010-10-15 2:00 AM, Björn Smedman wrote:
>> The ath9k ANI code may under some circumstances do division-by-zero. This
>> patch detects and avoids that case.
> Should be obsolete with my patch from 3 days ago:
> [PATCH 1/3] ath9k_hw: fix division by zero in the ANI monitor code

Yes it is. Thanks for catching and sorry for the wasted bandwidth.

/Björn
