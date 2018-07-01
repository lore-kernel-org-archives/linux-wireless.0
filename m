Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52284 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751528AbeGAFqp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 01:46:45 -0400
Message-ID: <f33f7344be4ce6fa280841d181f146f557b8ca39.camel@coelho.fi> (sfid-20180701_074744_924033_19B75F59)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>
Date: Sun, 01 Jul 2018 08:46:35 +0300
In-Reply-To: <5B37D248.6040008@broadcom.com>
References: <20180630114930.25738-1-luca@coelho.fi>
         <201806302128.sZFW1pVY%fengguang.wu@intel.com>
         <5B37D248.6040008@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211_hwsim: Add support for HE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-06-30 at 20:56 +0200, Arend van Spriel wrote:
> On 6/30/2018 5:42 PM, kbuild test robot wrote:
> >    2560			.he_mcs_nss_supp = {
> > > > 2561				.rx_msc_80 =
> > > > cpu_to_le16(0xfffa),
> > > > 2562				.tx_msc_80 =
> > > > cpu_to_le16(0xfffa),
> > > > 2563				.rx_msc_160 =
> > > > cpu_to_le16(0xffff),
> > > > 2564				.tx_msc_160 =
> > > > cpu_to_le16(0xffff),
> > > > 2565				.rx_msc_80p80 =
> > > > cpu_to_le16(0xffff),
> > > > 2566				.tx_msc_80p80 =
> > > > cpu_to_le16(0xffff),
> > 
> >    2567			},
> 
> I believe I commented in earlier version that those fields in the
> type 
> defintion should be mcs iso msc and this initializer did not get
> fixed?

Ugh, yes, this doesn't even compile with the code Johannes merged.  I
applied the patches on top of the old version of the cfg/mac changes...

I'll resend.

--
Cheers,
Luca.
