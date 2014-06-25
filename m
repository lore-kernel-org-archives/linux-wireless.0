Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59456 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaFYQsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 12:48:54 -0400
Message-ID: <53AAFD75.7090603@candelatech.com> (sfid-20140625_184857_915005_AB06CAAE)
Date: Wed, 25 Jun 2014 09:48:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [RFC] wireless: improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com> <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com> <20140623205451.GG1390@garbanzo.do-not-panic.com> <53A89A0F.9090509@candelatech.com> <20140624004442.GH1390@garbanzo.do-not-panic.com> <53A8E3F9.7000001@candelatech.com> <CAB=NE6XJaHNAL17mN7Ghw9GnatOwaOacikv5XupK7xKjUe=m_Q@mail.gmail.com>
In-Reply-To: <CAB=NE6XJaHNAL17mN7Ghw9GnatOwaOacikv5XupK7xKjUe=m_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I started trying to do some more DFS testing on a 3.14.8+ kernel,
and from what I can tell, the US region is configured for
DFS-Unset.  I was assuming this should be set to DFS_FCC.

I tried installing the latest regulatory.bin.  crda is whatever
is standard on Fedora 19.

Do you know if DFS is supposed to work at all in the 3.14 kernel?

I'm certain I had this working earlier on this machine,
but I was on a somewhat patched linux.ath tree at the
time it seems....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

