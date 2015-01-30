Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:47014 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbA3SSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 13:18:09 -0500
Message-ID: <54CBCADA.4050801@broadcom.com> (sfid-20150130_191813_704980_0F6DC467)
Date: Fri, 30 Jan 2015 19:18:02 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
References: <54C6A717.5050804@broadcom.com>
In-Reply-To: <54C6A717.5050804@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/15 21:44, Arend van Spriel wrote:
> Hi Hauke,
>
> The commit below causes the error mentioned in the Subject: field. I
> would like to fix this, but could use a bit of help here how to do this
> type of things.
>
> commit 4b681c82d2f9bef121c912ffcaac89a004af3f2c
> Author: Vadim Kochan <vadim4j@gmail.com>
> Date: Mon Jan 12 16:34:05 2015 +0200
>
> nl80211: Allow set network namespace by fd

Hi Hauke,

I looked into my issue a bit more. So my target kernel is 
3.11.1-200.fc19.x86_64 and checking lxr found that 3.11 has this 
function, but it does not have EXPORT_SYMBOL(). That was added by the 
same commit above. Any clues how to fix this?

Regards,
Arend

> Regards,
> Arend

