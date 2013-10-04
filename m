Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:39993 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3JDRii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 13:38:38 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so3411144lab.25
        for <linux-wireless@vger.kernel.org>; Fri, 04 Oct 2013 10:38:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Vcqrs-US-HJzxcnFhjF0-dsnvPdcWoUpuo-UDV_5cReQ@mail.gmail.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com> <CAB=NE6VQXQPRK9_Q-Nh+ripRa+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DFC5@HASMSX106.ger.corp.intel.com>
 <CAB=NE6WY43BYDehH5-MyF0GQORC1dTrNToUsRVC-Q5bDwcna3A@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD31E3C@HASMSX106.ger.corp.intel.com> <CAB=NE6Vcqrs-US-HJzxcnFhjF0-dsnvPdcWoUpuo-UDV_5cReQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 4 Oct 2013 10:38:16 -0700
Message-ID: <CAB=NE6WmEQg68BViF9v+2D__p8Gc_5bCFUkBMfTz0A96C1jyDw@mail.gmail.com> (sfid-20131004_193844_406077_E80FF093)
Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional channels
To: "Peer, Ilan" <ilan.peer@intel.com>,
	Jeff Johnson <jjohnson@qca.qualcomm.com>
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

On Thu, Jul 18, 2013 at 4:34 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Jul 17, 2013 at 12:15 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>>> It was unclear for what exact channels you needed to deal with here.
>>> Given review so far wouldn't it just be DFS flagged channels on some UNII
>>> bands ? Then again if the indoor flag needs to be pegged to to a specific UNII
>>> band and we can do that on wireless-regdb do we even need the UNII band
>>> check routine helper?
>>>
>>
>> Generally it is possible that the indoor property is not pegged to the 'other_channel', or it is possible that it is pegged but they are not in the same UNII band, so the verification is still needed. I guess that once I get the list you requested things will be clearer :)
>
> OK so there are exceptions to the indoor flag affecting GO under these
> rules or not. Looking forward to the respin.

Anxiously looking forward to the respin :D

  Luis
