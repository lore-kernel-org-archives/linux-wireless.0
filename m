Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53043 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0CMOBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 09:01:37 -0500
Received: by bwz1 with SMTP id 1so1779818bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 06:01:35 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
Date: Sat, 13 Mar 2010 15:01:31 +0100
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
References: <201002281534.11656.helmut.schaa@googlemail.com> <33ED094E-EFBC-4BAD-B9F4-4C81BCEE9537@cs.washington.edu> <1268203295.2446.30.camel@rchatre-DESK>
In-Reply-To: <1268203295.2446.30.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003131501.31524.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

Am Mittwoch 10 März 2010 schrieb reinette chatre:
> For this I think we need to set WIPHY_FLAG_CUSTOM_REGULATORY instead of
> WIPHY_FLAG_STRICT_REGULATORY. Looking closer it actually look as though
> this is a typo that slipped in with "cfg80211: convert bools to flags"
> where "hw->wiphy->custom_regulatory = true" was translated to
> "hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY" by mistake.
> 
> Can you please try by replacing WIPHY_FLAG_STRICT_REGULATORY with
> WIPHY_FLAG_CUSTOM_REGULATORY instead?

Works perfectly for me.

Thanks a lot,
Helmut

