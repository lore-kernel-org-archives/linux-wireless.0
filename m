Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40716 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752553AbdFUJOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 05:14:47 -0400
Message-ID: <1498036484.4955.4.camel@sipsolutions.net> (sfid-20170621_111454_942643_596B7B7D)
Subject: Re: [RFC] mac80211: support non-data TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Jun 2017 11:14:44 +0200
In-Reply-To: <23cd1255-32a3-84c2-77d1-4cd29bdc81dd@broadcom.com> (sfid-20170621_104829_756192_6F2088F1)
References: <20170620210309.1193-1-johannes@sipsolutions.net>
         <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
         <1498028959.4955.1.camel@sipsolutions.net>
         <1498034220.4955.3.camel@sipsolutions.net>
         <23cd1255-32a3-84c2-77d1-4cd29bdc81dd@broadcom.com>
         (sfid-20170621_104829_756192_6F2088F1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 10:48 +0200, Arend van Spriel wrote:
> 
> So for the sake of ath{9,10}k and possible future drivers you may
> want  to document it clearly in mac80211.h(?), ie. when driver does
> not want a  separate non-data txq they should use IEEE80211_NUM_TIDS.

Yeah, will do.

johannes
