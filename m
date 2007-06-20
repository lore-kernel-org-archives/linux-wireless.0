Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59159 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756803AbXFTDYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 23:24:11 -0400
Message-ID: <46789DD5.9080409@lwfinger.net>
Date: Tue, 19 Jun 2007 22:24:05 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Hong Liu <hong.liu@intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [patch]mac80211: add support for iwlist channel
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>	 <200706182212.55862.flamingice@sourmilk.net> <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
In-Reply-To: <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hong Liu wrote:
> 2nd try!

The indication that this is the second try belongs in the subject. In addition, you should create a 
new message and not reply to the previous try.
> 
> Add supported channels info in SIOCGIWRANGE implementation.
> 
> Signed-off-by: Hong Liu <hong.liu@intel.com>

The next line after the last "Signed-off-by" line should be three minus signs. That line indicates 
the end of the header for the patch. Between the --- line and the diff that begins the patch, you 
can include any information that you wish to send, but does not belong in the official commit message.

> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> index fcea8b2..3c09a93 100644

Larry

