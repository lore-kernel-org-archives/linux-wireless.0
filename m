Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:39573 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946490AbXD3RMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 13:12:32 -0400
Message-ID: <46361EE3.6060107@linux.intel.com>
Date: Mon, 30 Apr 2007 09:52:51 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Subject: Re: "Stable" branch of mac80211
References: <20070429194855.451b9e7c@logostar.upir.cz>
In-Reply-To: <20070429194855.451b9e7c@logostar.upir.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> Hi,
> 
> I've created a new 'stable' branch in my tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git). It
> contains patches that strip mac80211 down to a stable version. The purpose
> of this branch is to prepare mac80211 for vanilla inclusion.
...
> Currently, it contains following patches:
> 
>       mac80211: remove 802.11n parts
>       mac80211: remove WPA testing stuff
>       mac80211: remove hostapd ioctls
>       mac80211: remove nonstable iwpriv ioctls
>       mac80211: remove iwpriv ioctls with wext equivalent
>       mac80211: remove AP and WDS support

I'm curious what the criteria was for removing code from 'stable'  

Are there known bugs/oops?  Is it known to be broken, or ?  

For code we know we ultimately want to be redone, removed, or whatever, I can understand not wanting to merge the code.  However we ultimately want AP, WDS, and 802.11n.  At least with 802.11n, I haven't seen anything indicating the code needs to be done any differently than it is currently being done.  

I assume the entire new tree will be marked as 'experimental', so what is the advantage gained by pulling this code out now?

James
