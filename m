Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37988 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdGGLly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 07:41:54 -0400
Message-ID: <1499427711.4790.4.camel@sipsolutions.net> (sfid-20170707_134157_458956_493F7FFA)
Subject: Re: [PATCH 1/4] cfg80211: Check if PMKID attribute is of expected
 size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Fri, 07 Jul 2017 13:41:51 +0200
In-Reply-To: <20170707093612.GA5732@jouni.qca.qualcomm.com>
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
         <1499419676.4790.1.camel@sipsolutions.net>
         <20170707093612.GA5732@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-07-07 at 09:36 +0000, Jouni Malinen wrote:
> On Fri, Jul 07, 2017 at 11:27:56AM +0200, Johannes Berg wrote:
> > All applied, thanks.
> > 
> > How did you find these? Some of them go way back, after all, and I
> > don't think even coverity flagged them?
> 
> Through manual review of all the nl80211 attributes.. There have been
> somewhat similar issues flagged as security issues in various kernel
> components recently and that has triggered more scrutiny for the
> kernel interfaces.

Cool, thanks for that. I almost thought (hoped?) you had a (new) tool
to detect this :)

johannes
