Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56852 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2999357AbdD1UwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 16:52:06 -0400
Message-ID: <1493412712.2431.18.camel@sipsolutions.net> (sfid-20170428_225216_667709_9A42DFE1)
Subject: Re: [mac80211-next:pending 17/17] net/mac80211/sta_info.c:1996:18:
 error: 'RATE_INFO_FLAGS_HE_MCS' undeclared
From: Johannes Berg <johannes@sipsolutions.net>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org
Date: Fri, 28 Apr 2017 22:51:52 +0200
In-Reply-To: <201704290403.S5wry7iO%fengguang.wu@intel.com> (sfid-20170428_223257_680653_54EA58A8)
References: <201704290403.S5wry7iO%fengguang.wu@intel.com>
         (sfid-20170428_223257_680653_54EA58A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-04-29 at 04:30 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac8021
> 1-next.git pending
> head:   c7e12d92078f1789c8409523f81ad89fa8fe4bd8
> commit: c7e12d92078f1789c8409523f81ad89fa8fe4bd8 [17/17] mac80211:
> add support for HE RX rate reporting
> config: x86_64-kexec (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout c7e12d92078f1789c8409523f81ad89fa8fe4bd8
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net/mac80211/sta_info.c: In function 'sta_stats_decode_rate':
> > > net/mac80211/sta_info.c:1996:18: error: 'RATE_INFO_FLAGS_HE_MCS'
> > > undeclared (first use in this function)
> 
>       rinfo->flags = RATE_INFO_FLAGS_HE_MCS;
>                      ^~~~~~~~~~~~~~~~~~~~~~

Yeah, my bad - forgot to include a cfg80211 patch in that branch :)

johannes
