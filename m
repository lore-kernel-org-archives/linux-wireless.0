Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50275 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab3FCQRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 12:17:00 -0400
Message-ID: <51ACC16F.5030602@candelatech.com> (sfid-20130603_181704_199513_58A68C82)
Date: Mon, 03 Jun 2013 09:16:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
CC: Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] AR9287; WiFi AP Mode - Increase interbeacon duration
 of 100ms
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com> <CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com> <1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com> <1366084534.24187.YahooMailNeo@web193501.mail.sg3.yahoo.com> <CAJ-Vmoki6FUETFLkThp1AvZ3R_2kCd5Ro83OuvsfW0nZ5pfJ2w@mail.gmail.com> <1366194814.88121.YahooMailNeo@web193506.mail.sg3.yahoo.com> <CAJ-Vmokx0MbTC47+0fcRt9yQshfTaPEDte2A=7Ycn2bzwLSPxg@mail.gmail.com> <1366248389.18545.YahooMailNeo@web193503.mail.sg3.yahoo.com> <CAJ-VmomXz93U7HCmscd=NVZKQ+RFbty+Xh_wcOPYEDhX57ptbw@mail.gmail.com> <1366281249.7026.YahooMailNeo@web193504.mail.sg3.yahoo.com> <CAJ-VmokO+Tc+5k+=d2qiZSFQtrLFaHuYgpPK7r_OO5PKBue_TQ@mail.gmail.com> <1369118418.41680.YahooMailNeo@web193504.mail.sg3.yahoo.com> <CAJ-Vmo=533O+3tDhjbzyOd1PRMX0kJB8guCc_9xyiHioifteJg@mail.gmail.com> <1369642207.73507.YahooMailNeo@web193501.mail.sg3.yahoo.com> <1370254531.75129.YahooMailNeo@web193504.mail.sg3.yahoo.com>
In-Reply-To: <1370254531.75129.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2013 03:15 AM, sandeep suresh wrote:
> Hello All,
>      Gentle reminder; really will be greatful, if you can give me some directions on this, Please.
> Regards
> Sandeep
>
> *From:* sandeep suresh <sandeep.suresh@yahoo.co.in>
> *To:* Adrian Chadd <adrian@freebsd.org>; ath9k-devel <ath9k-devel@lists.ath9k.org>
> *Cc:* "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> *Sent:* Monday, 27 May 2013 1:40 PM
> *Subject:* AR9287; WiFi AP Mode - Increase interbeacon duration of 100ms
>
> Hello All,
>      This is regarding the inter beacon timing for AR9287 WiFi module when configured in WiFi Access Point mode. In this mode, the beacons are generated every
> 100ms by the WiFi AP. I have the following questions:
> 1. As per documentation available on the internet, the minimum inter beacon timing is 100ms. But can we increase the the inter beacon timing above this value?
> say 250ms, 500ms etc
> 2. As per standard, does increase in inter beacon time > 100ms, have any impact on the WiFi Clients connected to AR9287 WiFi AP? Even though I might test with
> some WiFi clients without any side effects but there may be some WiFi clients (which I might be unaware of )that might not work.
> 3. Has anyone attempted to do this? Please let me know if you have any observations on this?

We have been using a default of 250ms beacon timer for years in our ath9k APs.  Seems to work
just fine, but we mostly use them for internal testing with other ath9k systems acting as
the stations.

Thanks,
Ben

> Thanks & regards
> Sandeep
>
>
>
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

