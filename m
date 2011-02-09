Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42556 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1BIMHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:07:34 -0500
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mac80211:  Make STA disconnect messages warn instead of debug.
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
	<87y65q7hc3.fsf@purkki.adurom.net> <4D517908.6020003@candelatech.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 09 Feb 2011 14:07:31 +0200
In-Reply-To: <4D517908.6020003@candelatech.com> (Ben Greear's message of "Tue\, 08 Feb 2011 09\:10\:32 -0800")
Message-ID: <87tygd76nw.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>> Messages like these are in the category "business as usual", which
>> happens frequently when the device is moved. IMHO they are not really
>> warnings. I'm worried that making the messages more visible might
>> scare the users too much.
>
> To me it seems more useful than the network up/down messages that
> are already printed from the networking core.

You are not a normal user :) But what networking core messages are you
referring to? I don't recall seeing anything like that.

> That said, I don't feel strongly about this change, and it's certainly
> an easy patch for me to carry in my own tree.

I also don't have any strong opinion about this, just voiced my
concern.

-- 
Kalle Valo
