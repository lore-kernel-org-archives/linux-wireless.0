Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7947 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbdLANHm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 08:07:42 -0500
Message-ID: <1512133659.4827.50.camel@intel.com> (sfid-20171201_140745_912884_17BFDD14)
Subject: Re: [PATCH 1/5] mac80211: always update the PM state of a peer on
 MGMT / DATA frames
From: Luciano Coelho <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 01 Dec 2017 15:07:39 +0200
In-Reply-To: <1512130169.25588.11.camel@sipsolutions.net>
References: <20171029095111.17078-1-luca@coelho.fi>
         <20171029095111.17078-2-luca@coelho.fi>
         <1509353300.2637.2.camel@sipsolutions.net>
         <1512128925.4827.49.camel@intel.com>
         <1512130169.25588.11.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 13:09 +0100, Johannes Berg wrote:
> On Fri, 2017-12-01 at 13:48 +0200, Luciano Coelho wrote:
> > 
> > FTR, I'm sending a separate patch with the hwsim fix, as we agreed,
> > as
> > part of the patchset I'm sending today.
> > 
> 
> Still need a fix to the test case as well though :-)

Yeah, I guess you should hold this patch until the test fix reaches
hostap.  I'll leave that coordination with you. ;)

--
Cheers,
Luca.
