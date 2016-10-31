Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([198.147.22.87]:40906 "EHLO ore.jhcloos.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S946907AbcJaVEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 17:04:40 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-wireless@vger.kernel.org
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: Backwards 11ac
In-Reply-To: <89dd7bd2-f6de-ea90-79ee-65d73d264522@dd-wrt.com> (Sebastian
        Gottschall's message of "Mon, 31 Oct 2016 21:13:35 +0100")
References: <m3oa21ftno.fsf@carbon.jhcloos.org>
        <f8094de7-1357-a9d0-fee3-b28e06dd3bc7@dd-wrt.com>
        <m34m3sfjsv.fsf@carbon.jhcloos.org>
        <89dd7bd2-f6de-ea90-79ee-65d73d264522@dd-wrt.com>
Date: Mon, 31 Oct 2016 17:02:59 -0400
Message-ID: <m3y414dyf0.fsf@carbon.jhcloos.org> (sfid-20161031_220443_715269_4DCBB940)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "SG" == Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

JC>> Thanks for that info, but there is still the issue that download
JC>> bandwidth is limited to around 6 Mbps whereas upload bandwidth is around
JC>> 50 Mbps

SG> thats unusual. i do not suffer from this issue with the latest driver
SG> code and also never had it. but as i said. the visual tx rate doesnt
SG> matter and isnt a reason for any issue here.
SG> its just a number

Those numbers above are actual throughput, tested via rsync/ssh.  Even
adding in the rsync, ssh, tcp and ip overheads that is still worse than
the 11n-40 on the 2.4 band.  And of course backwards.

Does anyone have any explanation for the backwards bandwidth or solution
for how to fix it?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 0x997A9F17ED7DAEA6
