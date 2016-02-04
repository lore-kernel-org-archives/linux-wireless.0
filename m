Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45993 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbcBDMUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:20:00 -0500
Message-ID: <1454588396.2564.7.camel@sipsolutions.net> (sfid-20160204_132005_019711_93052526)
Subject: Re: mac80211_hwsim + iperf + netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 04 Feb 2016 13:19:56 +0100
In-Reply-To: <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com> (sfid-20160204_123214_106573_FAAAB8D4)
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
	 <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com>
	 (sfid-20160204_123214_106573_FAAAB8D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-04 at 12:32 +0100, Michal Kazior wrote:
> 
>  ip netns add ns1
>  ip netns exec ns1 bash # get the PID in the session and don't close
> it
>  iw phy phyX set netns $pid_of_that_shell
> 

If you also have a recent enough iw version, you can use 

iw phy phyX set netns name ns1

johannes
