Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57581 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3GIPlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:41:47 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: Re: [PATCH v13 1/2] cfg80211: add 'flags' to cfg80211_rx_mgmt()
Date: Tue, 9 Jul 2013 18:41:42 +0300
Message-ID: <2129661.ryxWndVai2@lx-vladimir> (sfid-20130709_174150_408988_00F71F42)
In-Reply-To: <1373382929.8241.3.camel@jlt4.sipsolutions.net>
References: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <2816930.mUJMdCmsNg@lx-vladimir> <1373382929.8241.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 09, 2013 05:15:29 PM Johannes Berg wrote:
> On Wed, 2013-07-03 at 17:37 +0300, Vladimir Kondratiev wrote:
> > Flags intended to report various auxiliary information.
> > Introduced flag NL80211_RXMGMT_FLAG_REPLIED to report
> > whether frame was replied by the device/driver.
> 
> This looks fine to me, but the patch is line-wrapped and won't apply:
> 
> > @@ -608,8 +608,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, 
> > u8 *datap, int len,
> 
> 
> 
> You also sent me at least three versions of it and I don't really want
> to figure out what that meant.
> 
> johannes
> 
My mailing system went crazy for couple of days. Sorry for this.
All versions should be the same. I'll resend anyway,
as patch 2 require some edition.

Thanks, Vladimir
