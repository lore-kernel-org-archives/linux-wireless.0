Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36678 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753291AbXCWS10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:27:26 -0400
Date: Fri, 23 Mar 2007 19:27:24 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Hong Liu <hong.liu@intel.com>
Cc: Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
Message-ID: <20070323192724.39334c96@griffin.suse.cz>
In-Reply-To: <1174535025.9000.25.camel@devlinux-hong>
References: <1174015698.3408.41.camel@devlinux-hong>
	<200703161328.41006.flamingice@sourmilk.net>
	<1174103177.3026.8.camel@localhost.localdomain>
	<20070318164506.GB5358@jm.kir.nu>
	<1174260946.8053.20.camel@localhost.localdomain>
	<1174535025.9000.25.camel@devlinux-hong>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Mar 2007 11:43:45 +0800, Hong Liu wrote:
> As far as mac80211 is concerned, I think the patch is not needed.
> mac80211 has done what it needed to do through the SIOC{S/G}IWAUTH
> interface.

Ok. Let's drop this patch.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
