Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36262 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLKXdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 18:33:05 -0500
Message-ID: <1449876779.2324.16.camel@sipsolutions.net> (sfid-20151212_003309_055511_8A7F47EF)
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 12 Dec 2015 00:32:59 +0100
In-Reply-To: <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com> (sfid-20151212_001801_158339_DCC9E024)
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
	 <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com>
	 (sfid-20151212_001801_158339_DCC9E024)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-12-11 at 15:17 -0800, Luis R. Rodriguez wrote:
> 
> I just tried a base config from opensuse, then localmodconfig, then
> 'make xenconfig' (which I need) and that worked. I can't debug
> further but I think this config might help debug this further:
> 
> http://drvbp1.linux-foundation.org/~mcgrof/tmp/config-iwl-fail.txt
> 
> So -- my new config works, but I have no idea what fixed it, a config
> option obviously. Not sure what though.
> 

Can you post the good one too?

johannes
