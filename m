Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52884 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaAGSfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 13:35:20 -0500
Received: by mail-ie0-f175.google.com with SMTP id x13so833290ief.20
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 10:35:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140107181333.GB7267@magnum.frso.rivierawaves.com>
References: <529CF2D6.1080008@gmail.com> <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
 <20140106150716.GA5358@magnum.frso.rivierawaves.com> <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com>
 <20140107102746.GA20561@magnum.frso.rivierawaves.com> <CAF8O4-xaNWO+tFS=0+ffR5aKf0Z+OWDBSPpnjYWUgP86Oiey2g@mail.gmail.com>
 <20140107181333.GB7267@magnum.frso.rivierawaves.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 7 Jan 2014 20:34:59 +0200
Message-ID: <CAF8O4-zE-EAMh4-HHFTM6FHEB76icTfpNWHZUR+VE5HWkvb5KA@mail.gmail.com> (sfid-20140107_193523_947052_4CD25DB0)
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state machine
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 8:13 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> On Tue, Jan 07, 2014 at 06:30:07PM +0200, Eyal Shapira wrote:
>> Thanks. Seems like we decided the AP doesn't support any MIMO rates.
>> This wasn't handled well and caused the search cycle for an optimal Tx
>> configuration to get stuck.
>> Can you try the attached patch ?
>>
> Working, thanks.
>

great. thanks for testing and again for reporting to begin with.

>> Also, any chance you can send a traffic capture of some beacons and the assoc ?
>> I'd like to understand why we come to the conclusion no MIMO is supported.
>>
> AP limitation, but here is a capture anyway.

ok. so everything here makes sense.
