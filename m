Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:41602 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbYBNS1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 13:27:01 -0500
Message-ID: <47B487EE.3030401@scherping.de> (sfid-20080214_182705_950177_A17CC1D1)
Date: Thu, 14 Feb 2008 19:26:54 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com> <47B2268D.7060205@scherping.de> <47B2B332.1030404@scherping.de> <D936D925018D154694D8A362EEB0892003A7FB3E@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003A7FB3E@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette schrieb:
> On Wednesday, February 13, 2008 1:07 AM, Richard Scherping  wrote:
> 
>>> iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated:
>>> iwl4965_is_associated(priv)=1; priv->assoc_id=0;
>>> priv->assoc_station_added=1
>> Simply uncommenting the check for priv->assoc_id to be
>> non-zero (line 2938 in iwl4965-base.c) made ad-hoc working.
>> Thanks for helping me to find this!
>> Does this change have any negative side effects?
>>
>> Richard
> 
> Could you please try the attached patch instead?

Works for me (iwl4965). Thanks!

Richard
