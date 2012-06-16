Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1174 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab2FPL53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 07:57:29 -0400
Message-ID: <4FDC7495.7010900@broadcom.com> (sfid-20120616_135804_517660_F25A64E0)
Date: Sat, 16 Jun 2012 13:57:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/9] brcm80211: smac: rework regulatory support
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <4FD860DD.4060700@broadcom.com> <20120613135007.GC3490@thinkpad-t410>
In-Reply-To: <20120613135007.GC3490@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 03:50 PM, Seth Forshee wrote:
> On Wed, Jun 13, 2012 at 11:43:57AM +0200, Arend van Spriel wrote:
>> On 06/05/2012 04:34 PM, Seth Forshee wrote:
>>> brcmsmac has its own internal regulatory implementation which attempts
>>> to enforce a Broadcom defined domain named X2. This code has no
>>> integration with mac80211 regulatory other than supplying regulatory
>>> hints, and thus each implementation operates independently of the other,
>>> enforcing conflicting sets of rules.
>>
>> Hi Seth,
>>
>> This series looks fine. I have sent two small comment replies on it.
>> Actually, only one reply is on the code change. I want to run some
>> testing today/tomorrow and let you know the results.
> 
> Thanks! I'll wait for the test results before sending v3 patches.

Hi Seth,

Tested the v2 patches a couple of nights now so I think you can go about
sending the v3 series. Tested the patches on x86, x86_64, and ppc64.

Gr. AvS


