Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65439 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2B2P7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 10:59:22 -0500
Received: by iagj37 with SMTP id j37so2815087iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 07:59:22 -0800 (PST)
Message-ID: <4F4E4B52.4070701@lwfinger.net> (sfid-20120229_165926_820834_88EEE52C)
Date: Wed, 29 Feb 2012 09:59:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	chunkeey@web.de
Subject: Re: [PATCH 4/5] p54pci: Load firmware from work queue and not from
 probe routine
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> <1329161826-11135-5-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1329161826-11135-5-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2012 01:37 PM, Larry Finger wrote:
> Drivers that load firmware from their probe routine have problems with the
> latest versions of udev as they get timeouts while waiting for user
> space to start. The problem is fixed by loading the firmware and starting
> mac80211 from a delayed_work queue. By using this method, most of the
> original code is preserved.
>
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ---
>
> This patch is compile tested only.
>
> Larry

Has anyone tested this patch? I would like to submit this series.

Thanks,

Larry

