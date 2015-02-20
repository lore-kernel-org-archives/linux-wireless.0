Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41636 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbBTCJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 21:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <36119.1424394185@turing-police.cc.vt.edu>
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
 <20150206235802.GA19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com>
 <20150210200027.GG19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>
 <20150220005344.GF20824@wotan.suse.de> <36119.1424394185@turing-police.cc.vt.edu>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 19 Feb 2015 18:09:04 -0800
Message-ID: <CAB=NE6VJEm9sL+KZFAAYHGR4=hEhT_NjM3k1W5tGEuXp98x2eg@mail.gmail.com> (sfid-20150220_030946_602689_A7426ECC)
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor regulatory setting
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2015 at 5:03 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 20 Feb 2015 01:53:44 +0100, "Luis R. Rodriguez" said:
>> Wider community:
>>
>> anyone aware of any *need* in the kernel to know whether one is indoor or
>> not on a device running Linux other than wifi? Clearly it should be something
>> that might be of interest to at least other RF devices, so that is at least
>> one possibilty to consider already, but what else?
>
> I can think of a lot of reasons for the kernel to make indoor/outdoor
> status available to userspace, but am coming up empty why the kernel itself
> should care....

Some devices enable regulatory control through the kernel, in such
cases the wireless-regdb is used and there is an INDOOR flag that
enables / disables specific functionality.

 Luis
