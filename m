Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58590 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdK0VrB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 16:47:01 -0500
Message-ID: <1511819218.5456.17.camel@sipsolutions.net> (sfid-20171127_224705_164537_D9EE14B2)
Subject: Re: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Peng Xu <pxu@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>
Date: Mon, 27 Nov 2017 22:46:58 +0100
In-Reply-To: <15034b29555b487bb172735015f5b78f@nasanexm01a.na.qualcomm.com>
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
         <1510664296.2030.22.camel@sipsolutions.net>
         <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
         <1510669408.2030.23.camel@sipsolutions.net>
         <929d1fdb74524aeaab4959f84a82c732@NASANEXM01F.na.qualcomm.com>
         <1510669995.2030.26.camel@sipsolutions.net>
         <e540b35f76a447cab35f7267c09ee8f5@NASANEXM01F.na.qualcomm.com>
         <20171114163127.GA24453@jouni.qca.qualcomm.com>
         <59a37842482b40ceb5e60c2155bca78c@NASANEXM01F.na.qualcomm.com>
         <1511784190.5456.13.camel@sipsolutions.net>
         <15034b29555b487bb172735015f5b78f@nasanexm01a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-27 at 19:14 +0000, Peng Xu wrote:
> > Is a new version of this patch hinging only on this? We'd love to have a fixed-
> > up one :-)
> 
> The new version covers the use cases mentioned by Jouni as the OUIs of the vendor commands 
> has the format of OUI + type + subtype. For other format of vendor commands, they will be treated
> as different vendor commands and are added in the new IE as well. 
> 
Sounds fine to me.

johannes
