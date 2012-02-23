Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BWXtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 18:49:23 -0500
Received: by iacb35 with SMTP id b35so2232677iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 15:49:23 -0800 (PST)
Message-ID: <4F46D080.4040909@lwfinger.net> (sfid-20120224_004927_857390_315251ED)
Date: Thu, 23 Feb 2012 17:49:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Attila Fazekas <turul64@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] Add AD-HOC support to the rtl8187 based on the rtl8180
 source
References: <1330023035-1833-1-git-send-email-turul64@gmail.com>
In-Reply-To: <1330023035-1833-1-git-send-email-turul64@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 12:50 PM, Attila Fazekas wrote:
> Add AD-HOC support to the rtl8187 based on the rtl8180 source
>
> Signed-off-by: Attila Fazekas<turul64@gmail.com>

You fixed the line wrapping problem. Good.

The subject of the mail should be "[PATCH] rtl8187: Add ....". That way the git 
log has the component being changed in the title of the submit. If the driver 
being patched is in the staging tree, then the line is "[PATCH] staging: 
drivername: title". When submitting a revised version, then use "[PATCH v2] ...".

When I tested this patch, I was not able to even see beacons this time with 
either an RTL8187L or RTL8187B. Could you please send me the commands or script 
that you are using to set up the ad-hoc connection?

Thanks,

Larry
