Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52416 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdCBNbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 08:31:03 -0500
Message-ID: <1488456958.8390.15.camel@sipsolutions.net> (sfid-20170302_143325_212181_2251C6BC)
Subject: Re: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
From: Johannes Berg <johannes@sipsolutions.net>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Thu, 02 Mar 2017 13:15:58 +0100
In-Reply-To: <b55e902d1a5445feb3058cee1118ae39@aphydexm01f.ap.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
         <1488444659.8390.8.camel@sipsolutions.net>
         <b55e902d1a5445feb3058cee1118ae39@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I think you need to define the bits somewhere in an enum - i.e.
> > which one is VO,
> > VI, ...
> > 
> 
> [Tamizh] ok sure. Is this for documentation purpose or do you want me
> to use that  enum for something else?

Well I think you should check in cfg80211 that no bits not defined in
the enum are used, and then in the driver you need to use that enum to
translate to the firmware API, right?

johannes
