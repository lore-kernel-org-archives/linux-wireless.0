Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46120 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbeAVNWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:22:34 -0500
Message-ID: <1516627352.2508.28.camel@sipsolutions.net> (sfid-20180122_142237_852519_AF34CD4F)
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Jan 2018 14:22:32 +0100
In-Reply-To: <59cebd66-44ca-4bfd-0be2-a6d37c0bfa75@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
         <1516018169.410.14.camel@sipsolutions.net>
         <59cebd66-44ca-4bfd-0be2-a6d37c0bfa75@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 15:39 +0100, Benjamin Beichler wrote:
> 
> 
> I really don't know, why there were 2 addresses introduced in the first
> place, and why the netlink operations for receiving only check against
> the second address and not the first address (see
> get_hwsim_data_ref_from_addr). My suggestion would be, only allocate one
> mac address and check against this one. I don't know, whether really any
> user of hwsim rely on the structure, that an adapter needs two mac
> addresses. Since this is part of the initial commit, this decision is
> not documented in git ...

Fair enough, let's leave it then.

johannes
