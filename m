Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41169 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3J3RGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 13:06:43 -0400
Message-ID: <52713C85.6070607@candelatech.com> (sfid-20131030_180646_656324_167756AD)
Date: Wed, 30 Oct 2013 10:06:13 -0700
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

I'll test these later today, thanks!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

