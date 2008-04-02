Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYDBSVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 14:21:32 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Wed, 2 Apr 2008 11:21:30 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194819@orsmsx416.amr.corp.intel.com> (sfid-20080402_192137_002818_CFBD9F67)
In-Reply-To: <1207092107.12301.18.camel@X61.NetworkingUnlimited.com>
References: <1207092107.12301.18.camel@X61.NetworkingUnlimited.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Vincent C Jones  wrote:

> Agree, it should not be necessary to use both iwconfig &
> wpa_supplicant, but somewhere between the last official release for
> Intel 4965 and the latest the 3/27/2008 release, it has become
> necessary, at least for some of us. SuSE 10.3, all kernels tried from
> 2.6.22 through 2.6.25-rc4. Some data points which might give
> you a clue:

To check we are using the same code ... could you please use the latest
iwlwifi driver by making use of the compat-wireless project
(http://linuxwireless.org/en/users/Download)?

> 
> Incidentally, should the 802.11n work using 802.11n draft on 5Ghz?

yes

Reinette
