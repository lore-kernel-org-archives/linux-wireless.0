Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52576 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbXC2McB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 08:32:01 -0400
Message-ID: <460BB1BD.8050100@garzik.org>
Date: Thu, 29 Mar 2007 08:31:57 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of wireless-2.6
References: <20070327182624.GC3887@tuxdriver.com> <20070327182653.GD3887@tuxdriver.com>
In-Reply-To: <20070327182653.GD3887@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit b1944354101f15f4afeffd842e12c7d70fb7e822:
>   John W. Linville (1):
>         Merge branch 'upstream-fixes' into upstream
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream
> 
> Daniel Drake (3):
>       zd1211rw: Mark some data const
>       zd1211rw: Don't handle broken frames in monitor mode
>       zd1211rw: Add another ID for Linksys WUSBF54G
> 
> Jouni Malinen (1):
>       Update my email address from jkmaline@cc.hut.fi to j@w1.fi
> 
>  MAINTAINERS                                   |    5 +++--
>  crypto/michael_mic.c                          |    4 ++--
>  drivers/net/wireless/hostap/hostap_ap.c       |    4 ++--
>  drivers/net/wireless/hostap/hostap_cs.c       |    2 +-
>  drivers/net/wireless/hostap/hostap_hw.c       |    4 ++--
>  drivers/net/wireless/hostap/hostap_main.c     |    4 ++--
>  drivers/net/wireless/hostap/hostap_pci.c      |    2 +-
>  drivers/net/wireless/hostap/hostap_plx.c      |    2 +-
>  drivers/net/wireless/ipw2100.c                |    4 ++--
>  drivers/net/wireless/zd1211rw/zd_mac.c        |   13 ++-----------
>  drivers/net/wireless/zd1211rw/zd_rf.c         |    2 +-
>  drivers/net/wireless/zd1211rw/zd_rf_al7230b.c |    4 ++--
>  drivers/net/wireless/zd1211rw/zd_rf_rf2959.c  |    4 ++--
>  drivers/net/wireless/zd1211rw/zd_usb.c        |    1 +
>  include/linux/wireless.h                      |    2 +-
>  include/net/ieee80211.h                       |    4 ++--
>  include/net/ieee80211_crypt.h                 |    4 ++--
>  net/ieee80211/ieee80211_crypt.c               |    2 +-
>  net/ieee80211/ieee80211_crypt_ccmp.c          |    2 +-
>  net/ieee80211/ieee80211_crypt_tkip.c          |    2 +-
>  net/ieee80211/ieee80211_crypt_wep.c           |    2 +-
>  net/ieee80211/ieee80211_module.c              |    4 ++--
>  net/ieee80211/ieee80211_rx.c                  |    4 ++--
>  net/ieee80211/ieee80211_wx.c                  |    4 ++--
>  24 files changed, 39 insertions(+), 46 deletions(-)

hrm, it doesn't seem to like my #upstream, can you wait a bit for 
kernel.org propagation, and then redo with these already merged?  Also, 
please pull branch libertas into your #upstream.

Auto-merged MAINTAINERS
Auto-merged drivers/net/wireless/libertas/debugfs.c
CONFLICT (add/add): Merge conflict in 
drivers/net/wireless/libertas/debugfs.c
Auto-merged include/net/ieee80211_radiotap.h
CONFLICT (content): Merge conflict in include/net/ieee80211_radiotap.h
Automatic merge failed; fix conflicts and then commit the result.
