Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbdJFJmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 05:42:52 -0400
Message-ID: <1507282969.19300.4.camel@sipsolutions.net> (sfid-20171006_114306_734858_B190F1B8)
Subject: Re: [RFC v2 1/2] fq: support filtering a given tin
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 06 Oct 2017 11:42:49 +0200
In-Reply-To: <87h8vdslpr.fsf@toke.dk>
References: <20171005131803.12328-1-johannes@sipsolutions.net>
         <87h8vdslpr.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-05 at 16:39 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Add to the FQ API a way to filter a given tin, in order to
> > remove frames that fulfil certain criteria according to a
> > filter function.
> > 
> > This will be used by mac80211 to remove frames belonging to
> > an AP VLAN interface that's being removed.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Yup, this version looks reasonable to me :)

Do you know if anyone feels responsible for the fq code?

Should I Cc netdev on these patches?

johannes
