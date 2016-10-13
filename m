Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48806 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752837AbcJMOzQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:55:16 -0400
Message-ID: <1476369047.3880.27.camel@coelho.fi> (sfid-20161013_165520_679744_D36B5016)
From: Luca Coelho <luca@coelho.fi>
To: Chris Rorvick <chris@rorvick.com>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        emmanuel.grumbach@intel.com, johannes@sipsolutions.net,
        kvalo@codeaurora.org, oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Date: Thu, 13 Oct 2016 17:30:47 +0300
In-Reply-To: <CAEUsAPaqyxA1=3ktisBO3Vrw9ygi7PSrk32Rw+iyHVe_WB1oyg@mail.gmail.com>
References: <1476349269.3880.18.camel@coelho.fi>
         <20161013102155.14547-1-luca@coelho.fi>
         <1476358075.1999.5.camel@tiscali.nl>
         <CAEUsAPaqyxA1=3ktisBO3Vrw9ygi7PSrk32Rw+iyHVe_WB1oyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 08:56 -0500, Chris Rorvick wrote:
> Hi Luca,
> 
> > On Thu, 2016-10-13 at 13:21 +0300, Luca Coelho wrote:
> > Could you please give this a spin? I have tested it with some handmade
> > ACPI tables in QEMU and it seems to work fine now.
> 
> 
> Tested-by: Chris Rorvick <chris@rorvick.com>
> 
> I think the debug output looks as expected, see below for the first 20
> lines or so.  And, more importantly, everything seems to be working!
> :-)

Yes, you got exactly what was expected.  Thanks for testing!

--
Luca.
