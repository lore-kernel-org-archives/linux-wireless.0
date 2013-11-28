Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39022 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab3K1DXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 22:23:55 -0500
Subject: Re: [PATCH] WIFI: handle a neglected case in
 nl80211_new_interface()
From: Chao Bi <chao.bi@intel.com>
To: Ujjal Roy <royujjal@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAE2MWk=WEwxbnBDhBRHKVQ7JhAwKANv-HQXyK=qTb4qaH4GZRg@mail.gmail.com>
References: <1385521254.23222.8.camel@bichao>
	 <CAE2MWk=WEwxbnBDhBRHKVQ7JhAwKANv-HQXyK=qTb4qaH4GZRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Nov 2013 11:53:38 +0800
Message-ID: <1385610818.7437.1.camel@bichao> (sfid-20131128_042419_232226_6739BD21)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-27 at 20:43 +0530, Ujjal Roy wrote:
> Hi,
> 
> 
> We can use IS_ERR_OR_NULL(wdev) to check NULL as well as error value.
> 
> Thanks,
> UjjaL
> 
> On Wed, Nov 27, 2013 at 8:30 AM, Chao Bi <chao.bi@intel.com> wrote:
>         In nl80211_new_interface(), it calls rdev_add_virtual_intf() to create
>         a new interface, however, it only checks whether returned value is err
>         code, but doesn't check if returned value is NULL. The returned 

Thanks Ujjal. I'll update it.


