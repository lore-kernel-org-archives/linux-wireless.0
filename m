Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:44088 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBWJoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 04:44:06 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so4233744lan.11
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 01:44:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A033385F7A@HASMSX106.ger.corp.intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com> <20140219001458.GF14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com>
 <20140219160301.GH14296@garbanzo.do-not-panic.com> <CB3B3D4774441E42AA3EA0E1BA8230A033383EED@HASMSX106.ger.corp.intel.com>
 <CAB=NE6WD93GCtsKpXUJB8pZ-+9wOcF1E4QxNX4rRyed26JCHoQ@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A033385C8E@HASMSX106.ger.corp.intel.com>
 <CAB=NE6VHVuRkxK0GbTNfkz2Cn+Bv19hO7cKe35KQhPVbUCB_bQ@mail.gmail.com> <CB3B3D4774441E42AA3EA0E1BA8230A033385F7A@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 23 Feb 2014 01:43:38 -0800
Message-ID: <CAB=NE6Vj9=fKu48DTXX10PnajSz4ThwToLGh3evNDe3kHsG78A@mail.gmail.com> (sfid-20140223_104435_287223_6498FC0A)
Subject: Re: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor channels
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 22, 2014 at 11:23 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
>>
>> On Sat, Feb 22, 2014 at 10:55 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> > AFAIK, one of the options they are considering is to allow such relaxation if
>> beacon from several (>1) different BSS was received.
>>
>> This can just go upstream, ie the existing implementation can be modified to
>> account for this for FCC only.
>>
>
> Yep ... this is WIP with the regulatory people ... need to get some answers ...

Tell them I said hi.

 Luis
