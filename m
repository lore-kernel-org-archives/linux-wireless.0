Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:43580 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752220AbZA0LQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 06:16:03 -0500
Message-ID: <497EECED.1020106@cosetrain.com> (sfid-20090127_121609_270806_57D96C0A)
Date: Tue, 27 Jan 2009 12:15:57 +0100
From: Florian Sesser <flomaillist@cosetrain.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/6] mac80211: More small changes for modularization
References: <497E1B90.4060803@cosetrain.com>	 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>	 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>	 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>	 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>	 (sfid-20090126_213927_757374_C1421A9C) <1233004598.4533.37.camel@johannes.local>
In-Reply-To: <1233004598.4533.37.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Thanks for your comment. My intention was having a logical seperation to
enable better discussion of my patch, which I think is pretty much of a
monster and not yet ready for inclusion?

What do you think about my selection of mesh_path_sel_ops and the
storing of mesh PP/PM/CC id?

If you deem it OK I would be happy to reformat the patch (into three or
so seperatly compiling patches) and include KConfigs.

Thanks,

Florian


Johannes Berg wrote:
> On Mon, 2009-01-26 at 21:39 +0100, Florian Sesser wrote:
>> Some rather small changes in various files.
>> After this patch, i was able to do a clean compile.
> 
> You need to ensure that after _every_ single patch.
> 
> johannes
