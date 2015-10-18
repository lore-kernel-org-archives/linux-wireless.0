Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36739 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbbJRSeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:34:22 -0400
Received: by lbcao8 with SMTP id ao8so127509549lbc.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2015 11:34:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445190425.31451.70.camel@decadent.org.uk>
References: <1445190425.31451.70.camel@decadent.org.uk>
Date: Sun, 18 Oct 2015 21:34:20 +0300
Message-ID: <CANUX_P00j7Ev=fMUS+0Eyy5GRR8U8m7H_aqu09Ae4cCwveGLnA@mail.gmail.com> (sfid-20151018_203426_523290_08AFCFF8)
Subject: Re: [PATCH] iwlwifi: Fix module firmware information for 3160
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2015 at 8:47 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> IWL3160_UCODE_API_OK is no longer defined, so we end up with this
> in the module information:
>
> firmware:       iwlwifi-3160-IWL3160_UCODE_API_OK.ucode
>
> It looks like IWL7260_UCODE_API_OK should be used instead now.
>
> Fixes: ed65918735a5 ("iwlwifi: 7000: modify the firmware name for 3165")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

picked up. Thanks.
