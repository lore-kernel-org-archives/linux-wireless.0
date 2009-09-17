Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:8667 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZIQMq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:46:27 -0400
Received: by an-out-0708.google.com with SMTP id d40so488060and.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 05:46:30 -0700 (PDT)
Message-ID: <4AB22FA3.2030004@lwfinger.net>
Date: Thu, 17 Sep 2009 07:46:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Bryan Wu <bryan.wu@canonical.com>, mb@bu3sch.de,
	stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power
 PHY
References: <4AA9B46E.8020100@canonical.com> <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com> 	<4AB0EDEB.9010803@canonical.com> <69e28c910909160813h2a91ff32hb5fa836f1f7a4963@mail.gmail.com> 	<4AB1AE43.6000602@canonical.com> <4AB1FAAB.1050103@canonical.com> <69e28c910909170535r26aabb14mfbd3e31223f56618@mail.gmail.com>
In-Reply-To: <69e28c910909170535r26aabb14mfbd3e31223f56618@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Try to enable mac80211/cfg80211 debug messages. Also enable SSB
> debugging. (If mac80211 debugging is on, then you are hitting a
> {mac|cfg|nl|lib}80211 bug, as your dmesg should contain entries like
> "device is no longer idle".)
> 
> To Larry: Software RFKILL is not yet implemented for LP-PHY - it is
> part of my calibration patch, which had other errors (software RFKILL
> is a prereq for calibration). Feel free to split it out into a
> separate patch if anyone needs it - I can't do it right now; no
> working Linux system (due to the vmware problem).

I have noticed that there is no notification of the radio switch being
off with the 4315; however, the radio is killed by the switch.

If I have time, I'll look at it, but I'm going to be travelling for 8
days and may not have much time.

Larry

