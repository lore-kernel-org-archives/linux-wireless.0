Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:48906 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbYBOVMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:12:45 -0500
Message-ID: <47B60044.9000801@scherping.de> (sfid-20080215_211248_999222_E9A06241)
Date: Fri, 15 Feb 2008 22:12:36 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Patrick Grimm <patrick@lunatiki.de>, linux-wireless@vger.kernel.org
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003ABCC4A@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892003ABCCAE@orsmsx416.amr.corp.intel.com> <200802150229.09602.patrick@lunatiki.de> <D936D925018D154694D8A362EEB0892003ABCF72@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003ABCF72@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette schrieb:
>>> One more question ... did ad-hoc work for you before this patch?
>> No. In my tests only ipw3945 works in Ad-Hoc mode.
> 
> ok - that explains things. The patch assumes that ad-hoc mode is
> working, which is unfortunately not the case. We have to fix this.
> 
> Reinette

As I said, I have tested with iwl4965 only. Seems as if there are more problems with ad-hoc and iwl3945.
Did ad-hoc work in the "old" iwl3945 (before the API change with old version 1.1.17, compared to new version 1.2.23/26)?

Richard
