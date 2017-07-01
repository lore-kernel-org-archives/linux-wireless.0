Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:34362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdGAVb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Jul 2017 17:31:28 -0400
Date: Sat, 01 Jul 2017 14:31:25 -0700 (PDT)
Message-Id: <20170701.143125.1505437308148938791.davem@davemloft.net> (sfid-20170701_233141_524022_A14C69C8)
To: sameo@linux.intel.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-nfc@lists.01.org
Subject: Re: [GIT] [4.13] NFC update
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170630093720.GO21214@zurbaran.ger.intel.com>
References: <20170630093720.GO21214@zurbaran.ger.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 30 Jun 2017 11:37:20 +0200

> This is the NFC pull request for 4.13. We have:
> 
> - A conversion to unified device and GPIO APIs for the
>   fdp, pn544, and st{21,-nci} drivers.
> - A fix for NFC device IDs allocation.
> - A fix for the nfcmrvl driver firmware download mechanism.
> - A trf7970a DT and GPIO cleanup and clock setting fix.
> - A few fixes for potential overflows in the digital and LLCP code.

Pulled, thanks Samuel.
