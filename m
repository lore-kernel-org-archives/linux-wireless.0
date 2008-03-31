Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57147 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYCaVAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:00:23 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: "Try to stop Tx aggregation on non active TID" messages
Date: Mon, 31 Mar 2008 14:00:21 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040FA21F@orsmsx416.amr.corp.intel.com> (sfid-20080331_220026_974222_D01CFE58)
In-Reply-To: <1206964750.5468.9.camel@johannes.berg>
References: <1206568750.22530.8.camel@johannes.berg> <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com> <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com> (sfid-20080330_125632_683065_10482C70) <1206964750.5468.9.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Johannes Berg  wrote:

> [1] as, incidentally, you can see in the current wireless tree from a
> few days ago, iwlwifi with debugging doesn't even compile!

Could you please send the errors you see? The debug flags recently
changed, so the following is needed:
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWL3945_DEBUG=y

Reinette

