Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35418 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1CXQtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 12:49:51 -0400
Received: by vxi39 with SMTP id 39so140144vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 09:49:49 -0700 (PDT)
Message-ID: <4D8B762A.4050106@lwfinger.net>
Date: Thu, 24 Mar 2011 11:49:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roland Vossen <rvossen@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: More log spam from brcm80211
References: <4D8B6D2D.3090505@lwfinger.net> <4D8B7361.8050803@broadcom.com>
In-Reply-To: <4D8B7361.8050803@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2011 11:37 AM, Roland Vossen wrote:
> Hello Larry,
>
> did you already try my preliminary patch (email that I sent you yesterday) for
> the previous log spam problem ?
>
> Regarding this new problem: I will get back to you shortly.

Yes, I sent mail yesterday saying that the patch worked. I had to do it manually 
as I'm using wireless-testing, not staging-next, and files have been renamed. I 
did a full test. With the patch none of the spam appeared in the logs, When I 
reverted it, the messages returned.

Larry

