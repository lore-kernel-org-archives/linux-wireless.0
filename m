Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:31941 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932470AbXBWR6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 12:58:21 -0500
Message-ID: <45DF2A66.5020903@linux.intel.com>
Date: Fri, 23 Feb 2007 09:54:46 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Ryan Hope <rmh3093@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: d80211-2.0.1 build against 2.6.20-mm2
References: <48f7fe350702230855n6b850331o110dff9bc9560b77@mail.gmail.com> <20070223183759.50dc8123@griffin.suse.cz>
In-Reply-To: <20070223183759.50dc8123@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> Hi,
> 
> On Fri, 23 Feb 2007 11:55:39 -0500, Ryan Hope wrote:
>> The latest version of d80211 does not build against the latest
>> mm-sources... Here is a patch to fix d80211 so that is DOES build
>> against 2.6.20-mm2:
>> http://www.rit.edu/~rmh3093/d80211-2.0.1-mm-fix.patch
> 
> The fix is already in wireless-dev. What do you mean by "the latest
> version of d80211"? The version from iwlwifi, d80211 -mm patch
> series, ...?
> 
>  Jiri

He's referring to the d80211 subsystem package which can be applied to 
2.6.18 or newer (see email 'FYI - new d80211 subsystem package...').

d80211-2.0.1 was based on wireless-dev pre any 2.6.21-rc1 fixes.  I'll 
add a kernel-API compatibility check for this change and respin 
d80211-3.0.0.

James



