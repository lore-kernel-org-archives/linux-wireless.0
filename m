Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58723 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1FXPNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 11:13:48 -0400
Received: by pzk9 with SMTP id 9so1833600pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 08:13:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308774283.29571.24.camel@jlt3.sipsolutions.net>
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com> <1308774283.29571.24.camel@jlt3.sipsolutions.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 24 Jun 2011 09:13:27 -0600
Message-ID: <BANLkTi=-=EbuijX-RLeyD-GKv+fFYf+B2g@mail.gmail.com> (sfid-20110624_171354_998101_2CB4DBA8)
Subject: Re: [3.0 regression] DMAR faults in iwlagn
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 2:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Andy, could you try this patch?
>
> I haven't tested it at all yet, it's kinda late here.
>
> johannes
>
> iwlagn: map command buffers BIDI

Works for me.

Tested-by: Andy Lutomirski <luto@mit.edu>

Thanks!
