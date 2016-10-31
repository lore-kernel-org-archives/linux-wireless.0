Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([198.147.22.87]:40902 "EHLO ore.jhcloos.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945543AbcJaShn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 14:37:43 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-wireless@vger.kernel.org
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: Backwards 11ac
In-Reply-To: <f8094de7-1357-a9d0-fee3-b28e06dd3bc7@dd-wrt.com> (Sebastian
        Gottschall's message of "Mon, 31 Oct 2016 00:43:46 +0100")
References: <m3oa21ftno.fsf@carbon.jhcloos.org>
        <f8094de7-1357-a9d0-fee3-b28e06dd3bc7@dd-wrt.com>
Date: Mon, 31 Oct 2016 14:35:44 -0400
Message-ID: <m34m3sfjsv.fsf@carbon.jhcloos.org> (sfid-20161031_193747_529488_FFF079E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "SG" == Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

SG> ath10k cannot show tx rates right now in a easy way. since tx rate
SG> handling is done by the cards own firmware and not by the mac80211
SG> wireless stack

Thanks for that info, but there is still the issue that download
bandwidth is limited to around 6 Mbps whereas upload bandwidth is around
50 Mbps.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 0x997A9F17ED7DAEA6
