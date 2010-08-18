Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46297 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab0HRSuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 14:50:35 -0400
Received: by gyd8 with SMTP id 8so335466gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Aug 2010 11:50:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282153819-27781-3-git-send-email-wey-yi.w.guy@intel.com>
References: <1282153819-27781-1-git-send-email-wey-yi.w.guy@intel.com>
	<1282153819-27781-3-git-send-email-wey-yi.w.guy@intel.com>
Date: Wed, 18 Aug 2010 20:50:32 +0200
Message-ID: <AANLkTikEKbHNtG0A=QdoxytSyBpG247=zdXOj1FmQ8Lw@mail.gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: use long monitor timer to avoid un-necessary reload
From: drago01 <drago01@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 7:50 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> For 5000 series of devices, use long monitor timer to check
> stuck tx queues.
>
> 5000 series device, it is being reported firmware got reload more
> often than necessary, so extend the timer to avoid un-necessary reload.

What about iwl5300 ?
As I noted in the other thread my 5300 was affected by said issue and
increasing the timeout fixed it.

Looks like an oversight to me.
