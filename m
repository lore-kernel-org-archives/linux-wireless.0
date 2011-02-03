Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43758 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1BCQFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 11:05:32 -0500
Received: by qwa26 with SMTP id 26so1047876qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 08:05:31 -0800 (PST)
Message-ID: <4D4AD27E.4080101@lwfinger.net>
Date: Thu, 03 Feb 2011 10:06:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 3/8] rtl8192cu: Add new driver code - Part 2
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net> <1296411100-5675-4-git-send-email-Larry.Finger@lwfinger.net> <20110203112813.GD3516@redhat.com>
In-Reply-To: <20110203112813.GD3516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2011 05:28 AM, Stanislaw Gruszka wrote:
> On Sun, Jan 30, 2011 at 12:11:35PM -0600, Larry.Finger@lwfinger.net wrote:
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: george0505 <george0505@realtek.com>
>> Cc: 'Zhaoming_Li' <chaoming_li@realsil.com.cn>
>> ---
>>  drivers/net/wireless/rtlwifi/rtl8192cu/fw.c  |  685 ++++++++++++++++
>>  drivers/net/wireless/rtlwifi/rtl8192cu/fw.h  |   97 +++
>>  drivers/net/wireless/rtlwifi/rtl8192cu/led.c |  143 ++++
>>  drivers/net/wireless/rtlwifi/rtl8192cu/led.h |   38 +
> This files duplicate with rtl8192ce, that need to be merged
> into one lib.
> 
> I'm not reading furhter, I will continue when you post
> patches without code duplication.

Thanks for reading this far. The files are not identical; however, they can be
merged.

Larry
