Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1679 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2KFKqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 05:46:09 -0500
Message-ID: <5098EA0C.1020806@broadcom.com> (sfid-20121106_114621_688357_33B19D34)
Date: Tue, 6 Nov 2012 11:44:28 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Daniel Wagner" <wagi@monom.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <5098B858.7090802@monom.org> <5098C7FF.2060308@monom.org>
 <5098E488.5020206@broadcom.com>
In-Reply-To: <5098E488.5020206@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/12 11:20, Arend van Spriel wrote:
> On 11/06/2012 09:19 AM, Daniel Wagner wrote:
>> On 06.11.2012 08:12, Daniel Wagner wrote:
>>> Hi Seth,
>>>
>>> I am owner of a MBA 2012 and the mainline driver is kind of 'not fun'
>>> (read broken). Since a few days I am using it and the situation improved
>>
>> it = your patch set on top of 3.7-rc3
>>
>> (/me should not write emails right after getting up)
>>
>>
> 
> Just looked at the screen shots. Only could read the last one. It seems
> to indicate a problem in the receive path.
> 
> Gr. AvS
Hi Daniel,

could you describe your hardware (lspci -nn), infrastructure (iw wlanx
link/scan) and kernel version?

I was trying Seth's patches with 4313 and 43224 devices on 3.7-rc3 as
well and did not run into anything like this.


Thanks
Piotr

