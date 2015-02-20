Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39427 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbbBTPCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 10:02:42 -0500
Message-ID: <54E74C8F.9020606@gmail.com> (sfid-20150220_160321_831820_FD7D59C9)
Date: Fri, 20 Feb 2015 10:02:39 -0500
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu, "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor regulatory
 setting
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com> <20150206235802.GA19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com> <20150210200027.GG19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>            <20150220005344.GF20824@wotan.suse.de> <36119.1424394185@turing-police.cc.vt.edu>
In-Reply-To: <36119.1424394185@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/19/2015 08:03 PM, Valdis.Kletnieks@vt.edu wrote:
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
>
That made me try to think of the possible uses for such a variable but I 
imagine that they can all be handled by userspace as well.
	Powering down GPS chips for energy consumption.
	Applying filters to cameras for fluorescent lights.
