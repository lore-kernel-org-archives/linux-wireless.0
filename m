Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1319 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423388Ab3FUStA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 14:49:00 -0400
Message-ID: <51C4A013.90403@broadcom.com> (sfid-20130621_204904_865455_9D2E9852)
Date: Fri, 21 Jun 2013 20:48:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Maximilian Engelhardt" <maxi@daemonizer.de>
cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: Poor wireless reception on BCM4313
References: <1624172.s6pnfBcJL7@fuchs>
In-Reply-To: <1624172.s6pnfBcJL7@fuchs>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2013 08:26 PM, Maximilian Engelhardt wrote:
> Hello developers,
>
> I'm having problems with the reception performance of my BCM4313 wireless
> card. The card is basically working fine, but the reception is quite bad
> compared to other wifi equipment. I first suspected a hardware problem, but
> after I tried Windows 7 with the same hardware and having no problem there I'm
> quite sure this is a software issue.

Can you sent contents of /sys/kernel/debug/brcmsmac/bcma*/hardware?

Regards,
Arend

