Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36723 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbHTNMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 09:12:46 -0400
Message-ID: <1440076363.6610.40.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150820_151253_148526_2AE9767A)
Subject: Re: [RFC v3 1/3] iwlwifi: mvm: add real TSO implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, sara.sharon@intel.com,
	ido@wizery.com, netdev@vger.kernel.org
Date: Thu, 20 Aug 2015 06:12:43 -0700
In-Reply-To: <1440058544-20342-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1440058544-20342-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1440058544-20342-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-20 at 11:15 +0300, Emmanuel Grumbach wrote:
> The segmentation is done completely in software. The
> driver creates several MPDUs out of a single large send.
> Each MPDU is a newly allocated SKB.
> A page is allocated to create the headers that need to be
> duplicated (SNAP / IP / TCP). The WiFi header is in the
> header of the newly created SKBs.
> 
> type=feature
> 
> Change-Id: I238ffa79cacc5bbdacdfbf3e9673c8d4f02b462a
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/tx.c | 513 +++++++++++++++++++++++++++++++---
>  1 file changed, 481 insertions(+), 32 deletions(-)


Ouch again.

This will be a NACK. Sorry.


