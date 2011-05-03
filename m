Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1ECUDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 16:03:46 -0400
Message-ID: <4DC05F9C.2070802@lwfinger.net> (sfid-20110503_220405_257895_19AC0FA6)
Date: Tue, 03 May 2011 15:03:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: John W Linville <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn,
	Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net> <20110503150105.GC18648@gere.osrc.amd.com>
In-Reply-To: <20110503150105.GC18648@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2011 10:01 AM, Borislav Petkov wrote:
> I think I have such a device in my Thinkpad:
>
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
>
> I could give them a run soon. Do you have them in a tree somewhere I
> could pull?

Your device is claimed by the new driver.

You can get the code from

git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192se.git

This tree is based on Linville's wireless-testing tree with these 12 patches 
applied.

Larry
