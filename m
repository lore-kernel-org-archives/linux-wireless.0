Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44474 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754066AbcJMM6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:58:50 -0400
Message-ID: <1476363353.1999.17.camel@tiscali.nl> (sfid-20161013_145923_598918_733474A2)
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
From: Paul Bolle <pebolle@tiscali.nl>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        chris@rorvick.com
Cc: linuxwifi@intel.com, emmanuel.grumbach@intel.com,
        johannes@sipsolutions.net, kvalo@codeaurora.org,
        oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2016 14:55:53 +0200
In-Reply-To: <1476362653.3880.25.camel@coelho.fi>
References: <1476349269.3880.18.camel@coelho.fi>
         <20161013102155.14547-1-luca@coelho.fi>
         <1476358075.1999.5.camel@tiscali.nl> <1476358222.3880.21.camel@coelho.fi>
         <1476362194.1999.11.camel@tiscali.nl> <1476362653.3880.25.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 15:44 +0300, Luca Coelho wrote:
>  Even though there is apparently something wrong with this part of the
> ACPI table on you laptop, since it doesn't match our specifications.
>  In any case, it's mostly harmless.

Would a correct implementation by Dell have any benefits for the users
of these laptops? In other words: should I bother somehow contacting
Dell and point them to this discussion in order to have them fix this?


Paul Bolle
