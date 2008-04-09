Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbYDIPn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 11:43:29 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH] Make IWLCORE a silent option not toconfuse iwl3945	users.
Date: Wed, 9 Apr 2008 08:38:31 -0700
Message-ID: <D936D925018D154694D8A362EEB089200424DA91@orsmsx416.amr.corp.intel.com> (sfid-20080409_164337_861196_372EB60B)
In-Reply-To: <20080409083025.GB17458@infradead.org>
References: <874pakhist.fsf@sparse.dyndns.org> <20080409083025.GB17458@infradead.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Christoph Hellwig" <hch@infradead.org>,
	"Jason Riedy" <jason@acm.org>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Christoph Hellwig  wrote:

> On Tue, Apr 01, 2008 at 11:28:34PM -0700, Jason Riedy wrote:
>> The iwl3945 (currently?) does not use iwlcore.  Either the iwlcore
>> documentation should change or the option should be silent.  This
>> patch follows the latter route.  IWL4965 already SELECTs IWLCORE,
>> so there should be no new problems.  Note that IWLWIFI_DEBUGFS and
>> IWLCORE_RFKILL have no suboptions for 4965, so they are grouped
>> together and given a description that includes "4965+" to indicate
>> they're not for the 3945 adapters.
> 
> Just kill the option entirely and build the core module for both in
> the makefile. 

iwlcore is not currently needed for 3945. We'll clean up the Kconfig
dependencies.

Thanks

Reinette
