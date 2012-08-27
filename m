Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelayi.jaist.ac.jp ([150.65.19.7]:64138 "EHLO
	mailrelayi.jaist.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2H0N6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 09:58:23 -0400
Subject: Re: [PATCH] mac80211: Various small fixes for cfg.c: mpath_set_pinfo()
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: LEO Airwarosu Yoichi Shinoda <shinoda@jaist.ac.jp>
In-Reply-To: <CAG6hwVPtKYVcZPOm_p6kCrEPOpsRS_Lc=rWEkEkYW+ZC-8wAcg@mail.gmail.com>
Date: Mon, 27 Aug 2012 22:58:21 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Message-Id: <51080DA4-0AD5-4737-A71A-750CA15656BF@jaist.ac.jp> (sfid-20120827_155827_006262_DC0769C9)
References: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp> <CAG6hwVPtKYVcZPOm_p6kCrEPOpsRS_Lc=rWEkEkYW+ZC-8wAcg@mail.gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2012/08/27, at 22:49, Thomas Pedersen wrote:

>> +       memset(pinfo, 0, sizeof(struct mpath_info));
>> +
> 
> This is probably up to personal preference, but IMO 'sizeof(*p)' is a
> little nicer since the compiler already knows the pointer type.


The 'sizeof(*p)' is okay for me. I will just leave it up to the maintainers.

--- shinoda

