Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38009 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1A1E1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 23:27:01 -0500
Received: by yib18 with SMTP id 18so902340yib.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 20:27:00 -0800 (PST)
Message-ID: <4D4245B7.1010906@lwfinger.net>
Date: Thu, 27 Jan 2011 22:27:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: raghunathan.kailasanathan@wipro.com
CC: linux-wireless@vger.kernel.org
Subject: Re: unable to put RTL8192SU in master mode
References: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D579@BLR-SJP-MB02.wipro.com> <4D4183BD.3060609@lwfinger.net> <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D5E7@BLR-SJP-MB02.wipro.com>
In-Reply-To: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D5E7@BLR-SJP-MB02.wipro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 10:05 PM, raghunathan.kailasanathan@wipro.com wrote:
>
> 
> Thanks Larry. I am using the 8712u, so it should be the realtek one. I am on
> a older kernel (2.6.27) hence using the staging one would require some backporting 
> effort.
> 
> BTW what are the key differences between both ? 

Only that r8712u works on 64-bit systems. In addition, it was cleaned up for
kernel inclusion. My starting source was a beta version that never got released.

Because it does not use mac80211, backporting might not be that difficult.

Larry

