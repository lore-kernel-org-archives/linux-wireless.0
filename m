Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53531 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdGGJgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 05:36:24 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Subject: Re: [PATCH 1/4] cfg80211: Check if PMKID attribute is of expected
 size
Date: Fri, 7 Jul 2017 09:36:14 +0000
Message-ID: <20170707093612.GA5732@jouni.qca.qualcomm.com> (sfid-20170707_113633_378971_D8123D97)
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
 <1499419676.4790.1.camel@sipsolutions.net>
In-Reply-To: <1499419676.4790.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 07, 2017 at 11:27:56AM +0200, Johannes Berg wrote:
> All applied, thanks.
>=20
> How did you find these? Some of them go way back, after all, and I
> don't think even coverity flagged them?

Through manual review of all the nl80211 attributes.. There have been
somewhat similar issues flagged as security issues in various kernel
components recently and that has triggered more scrutiny for the kernel
interfaces.

--=20
Jouni Malinen                                            PGP id EFC895FA=
