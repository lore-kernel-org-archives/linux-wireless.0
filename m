Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36598 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbdDLNUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 09:20:39 -0400
Message-ID: <1492003236.2855.5.camel@sipsolutions.net> (sfid-20170412_152046_164312_66D23FA4)
Subject: Re: [PATCH net-next v5 4/5] netlink: pass extended ACK struct to
 parsing functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Date: Wed, 12 Apr 2017 15:20:36 +0200
In-Reply-To: <20170412131708.GC1952@nanopsycho> (sfid-20170412_151713_065465_26DD76A7)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
         <20170412123408.22012-5-johannes@sipsolutions.net>
         <20170412131708.GC1952@nanopsycho> (sfid-20170412_151713_065465_26DD76A7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-12 at 15:17 +0200, Jiri Pirko wrote:
> Wed, Apr 12, 2017 at 02:34:07PM CEST, johannes@sipsolutions.net
> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Pass the new extended ACK reporting struct to all of the
> 
> Johannes, I wonder, is there a reason you ignore my comments about
> narrow descriptions? Why don't you use the whole line?

I don't think it makes sense. Text is easier to read if it's narrower,
80 columns was never desired (only 72), and frankly, I think discussing
the commit or comment line length is pretty useless.

johannes
