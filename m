Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43176 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdBJJld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 04:41:33 -0500
Message-ID: <1486719690.26422.0.camel@sipsolutions.net> (sfid-20170210_104138_739868_22714888)
Subject: Re: [PATCH v4 3/5] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 10 Feb 2017 10:41:30 +0100
In-Reply-To: <CAOq732LLG0UwwdUAimhosjVS+P98tiY=MsGAPFFkbtH1PNj_+A@mail.gmail.com> (sfid-20170210_103947_316227_78333C46)
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
         <20170125114344.8179-3-andrew.zaborowski@intel.com>
         <1486547933.24745.2.camel@sipsolutions.net>
         <CAOq732KyMG26f7X4NiOdChyF3Qq=X9YgvCunecai+UrQAByByA@mail.gmail.com>
         <1486557177.24745.8.camel@sipsolutions.net>
         <CAOq732LLG0UwwdUAimhosjVS+P98tiY=MsGAPFFkbtH1PNj_+A@mail.gmail.com>
         (sfid-20170210_103947_316227_78333C46)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I sent a version with this logic but came up with values that would
> still cause the continous events as in your example, specifically
> with a hyst of 3 and the reported RSSI values jumping between -51 and
> -47. This could be avoided by changing operators between "less than"
> and "less or equal" but I eventually sent a version with the "sticky"
> ranges you suggested, I think that is just as good.

Ah, I was just wondering why you'd sent a new version, hadn't checked
the difference yet :)

Thanks for the note.

johannes
