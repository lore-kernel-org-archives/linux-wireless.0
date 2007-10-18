Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40655
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbXJRN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 09:59:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: b43: cannot set channel to 12
Date: Thu, 18 Oct 2007 15:58:39 +0200
Cc: linux-wireless@vger.kernel.org
References: <jey7e1leh0.fsf@sykes.suse.de>
In-Reply-To: <jey7e1leh0.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710181558.39600.mb@bu3sch.de> (sfid-20071018_145910_232507_255A27E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 October 2007 21:37:31 Andreas Schwab wrote:
> The b43 driver in current wireless-2.6 cannot set the channel to 12:
> 
> # iwconfig wlan0 chan 12
> Error for wireless request "Set Frequency" (8B04) :
>     SET failed on device wlan0 ; Invalid argument
> 
> iwlist still lists the APs on channels 12 and 13.
> 
> This is a 4318 in a iBook G4, using firmware version 410.2160.

That seems to be a mac80211 regulatory problem, not a b43 bug.

-- 
Greetings Michael.
