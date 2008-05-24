Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:1331 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYEXXYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 19:24:35 -0400
Received: by yw-out-2324.google.com with SMTP id 9so733982ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2008 16:24:29 -0700 (PDT)
Message-ID: <1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com> (sfid-20080525_012441_209416_E2E0276F)
Date: Sun, 25 May 2008 02:24:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: regression iwl3945/mac80211: association times out since 2.6.26-rc1
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
	flamingice@sourmilk.net
In-Reply-To: <20080524182852.GA9722@robinhood.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520184859.GA8168@robinhood.home>
	 <20080521054743.GA9910@robinhood.home>
	 <20080524182852.GA9722@robinhood.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 9:29 PM, Michael S. Tsirkin
<m.s.tsirkin@gmail.com> wrote:
> On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
>> FYI, I created an item in bugzilla to track this
>> http://bugzilla.kernel.org/show_bug.cgi?id=10765
>
> As requested, more configuration and log files have been attached
> to this item.

It looks like also this issue should be fixed by ' mac80211: reorder
channel and freq reporting in wext scan report' patch.
http://article.gmane.org/gmane.linux.kernel.wireless.general/15177
Please try.
Thanks
Tomas
