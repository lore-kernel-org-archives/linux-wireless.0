Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39060 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2K2Pdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 10:33:38 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so12222645iea.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 07:33:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354193757.5254.7.camel@cumari.coelho.fi>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
 <1353998701-18171-21-git-send-email-arik@wizery.com> <1354193757.5254.7.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 29 Nov 2012 17:33:22 +0200
Message-ID: <CA+XVXfd-AFWo0s1DTXN_F0WojRf57FKVmODAXm5fq-+jNQe7Vg@mail.gmail.com> (sfid-20121129_163340_539894_2FCFE4DC)
Subject: Re: [PATCH 20/20] wl18xx: set last Tx rate from FW status
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2012 at 2:55 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-11-27 at 08:45 +0200, Arik Nemtsov wrote:
>> Obtain the last Tx rate from the FW status and translate it to
>> the mac80211 rate+flag format before sending it up via the Tx status.
>>
>> Bump up the min FW version to the first FW that supports the rate byte.
>
> This part of the comment doesn't apply anymore, because we already
> bumped and this change is not part of this rebased patch. ;)

Ah thanks. I'll remove it.

Arik
