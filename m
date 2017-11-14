Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43538 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbdKNOdR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 09:33:17 -0500
Message-ID: <1510669995.2030.26.camel@sipsolutions.net> (sfid-20171114_153352_092980_9FC40E8F)
Subject: Re: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Peng Xu <pxu@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 14 Nov 2017 15:33:15 +0100
In-Reply-To: <929d1fdb74524aeaab4959f84a82c732@NASANEXM01F.na.qualcomm.com>
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
         <1510664296.2030.22.camel@sipsolutions.net>
         <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
         <1510669408.2030.23.camel@sipsolutions.net>
         <929d1fdb74524aeaab4959f84a82c732@NASANEXM01F.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 
> > This may be right for the WFA/Microsoft OUI, but not necessary anything
> > else?
> > 
> 
> Right, I only considered the most common cases since I did not find a
> generic way to compare two vendor elements. Any suggestion?

Right, not really.

I'm not even sure why this is necessary anyway though, do we really
think vendors will expect to be able to put vendor IEs inside the
subelements and override the ones outside?

Is there even any point for the WFA ones? It seems WMM really ought to
be the same for all anyway, for example.

johannes
