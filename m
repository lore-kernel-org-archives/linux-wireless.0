Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35276 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1BHOEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 09:04:46 -0500
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mac80211:  Make STA disconnect messages warn instead of debug.
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 16:04:44 +0200
In-Reply-To: <1297115078-27773-1-git-send-email-greearb@candelatech.com> (greearb@candelatech.com's message of "Mon\,  7 Feb 2011 13\:44\:32 -0800")
Message-ID: <87y65q7hc3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This makes them more easily seen in /var/log/messages
> and the console, for instance.

Messages like these are in the category "business as usual", which
happens frequently when the device is moved. IMHO they are not really
warnings. I'm worried that making the messages more visible might
scare the users too much.

-- 
Kalle Valo
