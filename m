Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59961 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1AQW0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 17:26:22 -0500
Received: by vws16 with SMTP id 16so2201382vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 14:26:21 -0800 (PST)
Message-ID: <4D34C225.4060108@lwfinger.net>
Date: Mon, 17 Jan 2011 16:26:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Logs spammed by associate / authenticate / CRDA calls
References: <4D34A421.3070804@lwfinger.net> <AANLkTin_DESckMrOMK41z3oJtXwmHvL026Mi8ayLeKLA@mail.gmail.com> <4D34BC83.2030406@candelatech.com>
In-Reply-To: <4D34BC83.2030406@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2011 04:02 PM, Ben Greear wrote:
> On 01/17/2011 12:26 PM, Daniel Halperin wrote:
>> On Mon, Jan 17, 2011 at 12:18 PM, Larry Finger
>>
>> Scanning happens every time you associate/re-associate; disassociation
>> due to inactivity happens when your device doesn't send packets to the
>> AP for some period of time.  It looks like your AP's (or device's)
>> timeout is 100s.
> 
> From what I can tell, this message can also happen if the local
> STA thinks it cannot connect to the remote.  For instance, if it
> doesn't get a TX callback within 500ms for ath5k/ath9k (and perhaps
> others).

Thanks Dan and Ben. It is clearly not an ordinary timeout from inactivity as it
happens even when I'm doing a download. I'll push it back to the Realtek people
to see if they can figure out a cause.

Larry
