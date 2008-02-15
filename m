Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:37493 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbYBOV3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:29:21 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Fri, 15 Feb 2008 13:21:36 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABD359@orsmsx416.amr.corp.intel.com> (sfid-20080215_212929_871896_20F6FCB3)
In-Reply-To: <47B60044.9000801@scherping.de>
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003ABCC4A@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892003ABCCAE@orsmsx416.amr.corp.intel.com> <200802150229.09602.patrick@lunatiki.de> <D936D925018D154694D8A362EEB0892003ABCF72@orsmsx416.amr.corp.intel.com> <47B60044.9000801@scherping.de>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Richard Scherping" <richard@scherping.de>
Cc: "Patrick Grimm" <patrick@lunatiki.de>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, February 15, 2008 1:13 PM, Richard Scherping  wrote:

> Chatre, Reinette schrieb:
>>>> One more question ... did ad-hoc work for you before this patch?
>>> No. In my tests only ipw3945 works in Ad-Hoc mode.
>> 
>> ok - that explains things. The patch assumes that ad-hoc mode is
>> working, which is unfortunately not the case. We have to fix this.
>> 
>> Reinette
> 
> As I said, I have tested with iwl4965 only. Seems as if there
> are more problems with ad-hoc and iwl3945.

I understand. Thanks for your testing. There indeed appears to be more
problems with ad-hoc and iwl3945, but they are unrelated to the patch
that you tested.

> Did ad-hoc work in the "old" iwl3945 (before the API change
> with old version 1.1.17, compared to new version 1.2.23/26)?

This needs to be checked. We do have some bug reports about ad-hoc mode
in iwl3945 (see http://www.bughost.org/bugzilla/show_bug.cgi?id=1472).
In this case it was specific to ad-hoc mode in b mode. We will look more
into ad-hoc mode with iwl3945.

Reinette
