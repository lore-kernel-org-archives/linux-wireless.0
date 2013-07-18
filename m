Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52860 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880Ab3GRXep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 19:34:45 -0400
Received: by mail-lb0-f173.google.com with SMTP id v1so3017372lbd.18
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jul 2013 16:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E3C@HASMSX106.ger.corp.intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com> <CAB=NE6VQXQPRK9_Q-Nh+ripRa+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DFC5@HASMSX106.ger.corp.intel.com>
 <CAB=NE6WY43BYDehH5-MyF0GQORC1dTrNToUsRVC-Q5bDwcna3A@mail.gmail.com> <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E3C@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 18 Jul 2013 16:34:23 -0700
Message-ID: <CAB=NE6Vcqrs-US-HJzxcnFhjF0-dsnvPdcWoUpuo-UDV_5cReQ@mail.gmail.com> (sfid-20130719_013448_867273_2F6EC6AE)
Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional channels
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "Spinadel, David" <david.spinadel@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, Jouni Malinen <j@w1.fi>,
	"Ginsburg, Noam" <noam.ginsburg@intel.com>,
	"Perelmooter, Liraz" <liraz.perelmooter@intel.com>,
	"Shalev, Oz" <oz.shalev@intel.com>,
	Michael Green <green@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 17, 2013 at 12:15 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> It was unclear for what exact channels you needed to deal with here.
>> Given review so far wouldn't it just be DFS flagged channels on some UNII
>> bands ? Then again if the indoor flag needs to be pegged to to a specific UNII
>> band and we can do that on wireless-regdb do we even need the UNII band
>> check routine helper?
>>
>
> Generally it is possible that the indoor property is not pegged to the 'other_channel', or it is possible that it is pegged but they are not in the same UNII band, so the verification is still needed. I guess that once I get the list you requested things will be clearer :)

OK so there are exceptions to the indoor flag affecting GO under these
rules or not. Looking forward to the respin.

  Luis
