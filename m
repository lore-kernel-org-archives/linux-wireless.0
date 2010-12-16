Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37279 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0LPQap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 11:30:45 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1292516015.27593.26.camel@wwguy-ubuntu>
References: <AANLkTink67RM4mp537UxFcx4g-9Dx+ymbW0A=cCu3C4g@mail.gmail.com>
	<1292516015.27593.26.camel@wwguy-ubuntu>
Date: Thu, 16 Dec 2010 17:30:44 +0100
Message-ID: <AANLkTi=vNpEKRDLcrudQhax=3HG=gqsMoCdU2RmOGMSj@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix error: struct iwl_lq_sta has no member named dbg_fixed_rate
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	John Linville <linville@tuxdriver.com>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 5:13 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Sedat,
>
> On Thu, 2010-12-16 at 03:46 -0800, Sedat Dilek wrote:
>> Attached patch fixes an issue with linux-next (20101216) and iwlwifi (see [1]).
>>
>> - Sedat -
>>
>> [1] http://lkml.org/lkml/2010/12/16/101
>
> ACKed-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> Thank you very much for catch this mistake and fix it so quickly.
>
> Wey
>
>

N.p., the patch is now in wireless-next-2.6 GIT master (so we will
have it in next-20101217).
Thanks John.

- Sedat -
