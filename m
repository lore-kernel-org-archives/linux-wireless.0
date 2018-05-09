Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934820AbeEIQ5J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 12:57:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 May 2018 09:57:08 -0700
From: Jeff Johnson <jjohnson@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Micha?= =?UTF-8?Q?el_B=C3=BCsch?= <m@bues.ch>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix regression caused by disabling PCI cores on
 non-MIPS architecture
In-Reply-To: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
References: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
Message-ID: <d31853aa21d1c610d09bce696423cfe2@codeaurora.org> (sfid-20180509_185713_089714_DE45439A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-09 09:42, Larry Finger wrote:
> Some MPIS-based SoCs use chips driven by b43 for wireless capability.
typo: MPIS=>MIPS
