Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35955 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcDNUuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:50:52 -0400
Received: by mail-oi0-f66.google.com with SMTP id v126so11366904oia.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 13:50:52 -0700 (PDT)
Subject: Re: [PATCH 00/16] rtl8xxxu - additional fixes
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Cc: kvalo@codeaurora.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <571002AA.9020602@lwfinger.net> (sfid-20160414_225055_962363_A38D83D6)
Date: Thu, 14 Apr 2016 15:50:50 -0500
MIME-Version: 1.0
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/2016 03:37 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Hi,
>
> This is a second set of rtl8xxxu related patches, which goes on top of
> the set I sent out earlier today. If you only have time to go through
> one set, please look at the other set.
>
> This set primarily contains fixes to make rtl8188ru v2 devices work
> again. I have reports that v1 devices still don't work, but I don't
> have one of those, so I am not able to test this.
>
> This also includes a fix for a crash reported by Xose Vazquez Peres
> when trying to hot add a USB ID. It marks 0x050d:0x1004 as tested,
> reported by Andrea Merello, and handles an old bug where the
> driver didn't unregister from mac80211 before shutting down the
> device. Last it includes a uninitialized return value fix from Colin
> Ian King.

I can confirm that the rtl8188ru v1 devices still do not work. Using "iwlist 
scan", my APs at 2m have signal levels from -90 to -98 dBm. I do not know if it 
is a problem in setting the gain, or if the antenna selection is wrong.

By the way, I have the same problem with the rtl8723bu device.

Larry


