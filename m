Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763321AbZATALR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 19:11:17 -0500
Subject: Re: [PATCH 14/15] iwlwifi: add recognition of Intel WiFi Link 6000
	and 6050 Series
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>
In-Reply-To: <1232408084.8866.29.camel@johannes.local>
References: <> <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-12-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-13-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-14-git-send-email-reinette.chatre@intel.com>
	 <1232407835-19451-15-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090120_003051_399866_7436A6F3)  <1232408084.8866.29.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 16:13:38 -0800
Message-Id: <1232410418.11197.53.camel@rc-desk> (sfid-20090120_011141_836718_20C52D78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-19 at 15:34 -0800, Johannes Berg wrote:
> On Mon, 2009-01-19 at 15:30 -0800, Reinette Chatre wrote:
> > From: Jay Sternberg <jay.e.sternberg@linux.intel.com>
> > 
> > add configuration for new Intel WiFi Link Series as part of the iwlagn
> > driver under the umbrella of 5000 family of devices.
> 
> Shouldn't the 6000 be mentioned in Kconfig too then?

yes it should - we will add it when the support can be more visible

Reinette

