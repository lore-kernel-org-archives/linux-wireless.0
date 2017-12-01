Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58918 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752565AbdLAMJb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 07:09:31 -0500
Message-ID: <1512130169.25588.11.camel@sipsolutions.net> (sfid-20171201_130948_397155_A00BCFEB)
Subject: Re: [PATCH 1/5] mac80211: always update the PM state of a peer on
 MGMT / DATA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 01 Dec 2017 13:09:29 +0100
In-Reply-To: <1512128925.4827.49.camel@intel.com>
References: <20171029095111.17078-1-luca@coelho.fi>
         <20171029095111.17078-2-luca@coelho.fi>
         <1509353300.2637.2.camel@sipsolutions.net>
         <1512128925.4827.49.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 13:48 +0200, Luciano Coelho wrote:
> 
> FTR, I'm sending a separate patch with the hwsim fix, as we agreed, as
> part of the patchset I'm sending today.
> 

Still need a fix to the test case as well though :-)

johannes
