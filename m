Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60320 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3XmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 19:42:22 -0400
Message-ID: <5271993E.5010103@candelatech.com> (sfid-20131031_004225_490435_4A1B0FF6)
Date: Wed, 30 Oct 2013 16:41:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH/RFT 00/12] ath10k: pci fixes 2013-10-30
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2013 04:42 AM, Michal Kazior wrote:
> Hi,
> 
> This patchset contains a slew of PCI/CE cleanups
> and fixes. The aim of the patchset is to deal with
> CE null dereference bugs Ben has been reporting on
> the mailing list for some time now.
> 
> I've done some brief testing and don't see any
> major regressions. I wasn't able to reproduce the
> reported bugs though. @Ben: Could you perhaps test
> this, please?

I have done a bit of testing on this.  First, I did see
a total machine lockup, but I have been seeing those fairly
often on module reloads, so probably that was nothing new
in your patches.

I am also still running the crash avoidance patches I posted
recently.

And good news for me at least...with some modified firmware,
I am getting two stations to associate to the same AP and
pass traffic to each other (no encryption..that probably
doesn't work yet) :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

