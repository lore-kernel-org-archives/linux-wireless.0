Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44613 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754692AbcJML2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:28:03 -0400
Message-ID: <1476358075.1999.5.camel@tiscali.nl> (sfid-20161013_132845_590442_AEFE2E6C)
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
From: Paul Bolle <pebolle@tiscali.nl>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        chris@rorvick.com
Cc: linuxwifi@intel.com, emmanuel.grumbach@intel.com,
        johannes@sipsolutions.net, kvalo@codeaurora.org,
        oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2016 13:27:55 +0200
In-Reply-To: <20161013102155.14547-1-luca@coelho.fi>
References: <1476349269.3880.18.camel@coelho.fi>
         <20161013102155.14547-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca,

On Thu, 2016-10-13 at 13:21 +0300, Luca Coelho wrote:
> Could you please give this a spin? I have tested it with some handmade
> ACPI tables in QEMU and it seems to work fine now.

Tested-by: Paul Bolle <pebolle@tiscali.nl>

Not that this test was worth a lot: it builds cleanly (on top of
4.8.1), the error at boot is gone, obviously, and wifi still works (as
you're reading a message that was sent out over wifi). And I haven't
even tested this on another machine than my XPS 13 (9350).

Thanks!


Paul Bolle
