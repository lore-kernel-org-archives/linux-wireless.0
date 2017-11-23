Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47048 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752231AbdKWGOc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 01:14:32 -0500
Message-ID: <1511417657.4011.322.camel@coelho.fi> (sfid-20171123_071436_839662_87980C39)
From: Luca Coelho <luca@coelho.fi>
To: Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Thu, 23 Nov 2017 08:14:17 +0200
In-Reply-To: <1511402153.14687.17.camel@decadent.org.uk>
References: <1510767968.4011.124.camel@coelho.fi>
         <1511402153.14687.17.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi firmwares update 2017-11-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-11-23 at 01:55 +0000, Ben Hutchings wrote:
> On Wed, 2017-11-15 at 19:46 +0200, Luca Coelho wrote:
> > Hi Kyle,
> > 
> > This pull-request supersedes my previous one.
> > 
> > I have updated the firmwares for the 3160, 3168, 7260, 7265D, 8000C
> > and
> > 8265 devices and added new FW versions for 8000C, 8265 and the new
> > 9000
> > series.
> > 
> > Please pull or let me know if there are any issues.
> 
> Pulled, thanks.  However, I had to a fix up a typo in WHENCE
> afterward.
>  In future, please remember to run 'make check' to validate it.

Thanks, Ben! Sorry for the typo, I didn't know about 'make check', I'll
make sure I run it every time before sending new pulls from now on.

--
Cheers,
Luca.
