Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f185.google.com ([209.85.222.185]:57156 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756Ab0FEXzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 19:55:22 -0400
Received: by pzk15 with SMTP id 15so1658384pzk.15
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 16:55:22 -0700 (PDT)
Message-ID: <4C0AE3FF.70204@lwfinger.net>
Date: Sat, 05 Jun 2010 18:55:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jason Dravet <dravet@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add support for Dell WLA3310 USB card
References: <SNT144-w4640D712F57F1472EF0A16DFD30@phx.gbl>,<4C0AABA8.9010401@lwfinger.net> <SNT144-w576DCA1E748A7C631A1B77DFD30@phx.gbl>
In-Reply-To: <SNT144-w576DCA1E748A7C631A1B77DFD30@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2010 06:43 PM, Jason Dravet wrote:
>  
> Thank you Larry.  I appreciate it.  I will RTFM for next time.  How is the firmware issue going to be solved?
>  

The user will need to sort that out. The driver will tell them what file
name should be used. That kind of info should not be in the commit
message as the users would not see it, and the developers do not need
it. The wiki is a better place.

Larry
