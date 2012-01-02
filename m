Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45641 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2ABRIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:08:20 -0500
Message-ID: <4F01E480.2070800@lwfinger.net> (sfid-20120102_180825_624774_749E7158)
Date: Mon, 02 Jan 2012 11:08:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>,
	torvalds@linux-foundation.org
CC: chaoming_li@realsil.com.cn, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192ce: rtl8192cu: Delay firmware file read
 until needed to fix at drivers/base/firmware_class.c:537
References: <4effd8e3.n1quWeZQBSRwqFJt%Larry.Finger@lwfinger.net>
In-Reply-To: <4effd8e3.n1quWeZQBSRwqFJt%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/31/2011 09:54 PM, Larry Finger wrote:
> A recent LKML thread (http://lkml.indiana.edu/hypermail/linux/kernel/1112.3/00965.html)
> discusses the the WARNING listed below, which occurs after a suspend/resume cycle. For
> rtl8192cu, the problem was fixed by delaying the firmware loading until the interface is
> brought up. By this time, the userspace support is available.

John,

Please drop this patch. The "fix" only cures the symptom, not the underlying 
cause. I will rework and resubmit.

Thanks,

Larry
