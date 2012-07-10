Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4986 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab2GJMiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 08:38:22 -0400
Message-ID: <4FFC2235.5080801@broadcom.com> (sfid-20120710_143826_811089_D9226F2C)
Date: Tue, 10 Jul 2012 14:38:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel oops on wireless-testing
References: <4FFC0BA2.3060107@broadcom.com> (
 sfid-20120710_130212_744547_93D9E56B)
 <1341918560.4475.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341918560.4475.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 01:09 PM, Johannes Berg wrote:
> On Tue, 2012-07-10 at 13:01 +0200, Arend van Spriel wrote:
>> Recently I get a kernel oops in nightly test on the wireless-testing
>> tree (see below). This is on 3.5-rc4 kernel based on following commit:
>>
>> commit a5b846deb890fbea72267e4e7d98f8f022959d14
>> Merge: 1532e30 bf52592
>> Author: John W. Linville <linville@tuxdriver.com>
>> Date:   Wed Jun 27 16:15:29 2012 -0400
>>
>>     Merge branch 'master' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/linvi
>>
>> Can this be expected (eg. recent change in struct wiphy) ? I will built
>> a new kernel from wireless-testing and see if that helps.
> 
> Why would you expect this? Are you running new modules on an old kernel?
> 
> johannes
> 
> 

Yes. I do not built the whole kernel upon wireless-testing update. So I
generally built cfg80211, mac80211, and our own drivers. That mostly
works except that (part of) wext can only be built in-kernel.

btw, moving to a newer kernel worked for me so it is a user issue. Sorry
for the noise.

Gr. AvS


