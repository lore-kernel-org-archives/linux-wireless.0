Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754361AbcJMLzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:55:14 -0400
Message-ID: <1476358222.3880.21.camel@coelho.fi> (sfid-20161013_135519_972069_302A3AD5)
From: Luca Coelho <luca@coelho.fi>
To: Paul Bolle <pebolle@tiscali.nl>, linux-wireless@vger.kernel.org,
        chris@rorvick.com
Cc: linuxwifi@intel.com, emmanuel.grumbach@intel.com,
        johannes@sipsolutions.net, kvalo@codeaurora.org,
        oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2016 14:30:22 +0300
In-Reply-To: <1476358075.1999.5.camel@tiscali.nl>
References: <1476349269.3880.18.camel@coelho.fi>
         <20161013102155.14547-1-luca@coelho.fi>
         <1476358075.1999.5.camel@tiscali.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 13:27 +0200, Paul Bolle wrote:
> Luca,
> 
> On Thu, 2016-10-13 at 13:21 +0300, Luca Coelho wrote:
> > Could you please give this a spin? I have tested it with some handmade
> > ACPI tables in QEMU and it seems to work fine now.
> 
> 
> Tested-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Not that this test was worth a lot: it builds cleanly (on top of
> 4.8.1), the error at boot is gone, obviously, and wifi still works (as
> you're reading a message that was sent out over wifi). And I haven't
> even tested this on another machine than my XPS 13 (9350).

Thanks for testing!

I forgot to say... could you load the iwlwifi module with debug=0x01
(module parameter), so we can see the messages the driver is printing
when it doesn't find a proper structure?

--
Luca.
