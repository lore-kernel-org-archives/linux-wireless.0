Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43905 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYDCQPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:15:23 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] Make IWLCORE a silent option not to confuse iwl3945 users.
Date: Thu, 3 Apr 2008 09:14:23 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com> (sfid-20080403_171526_959408_7DE7CEA4)
In-Reply-To: <874pakhist.fsf@sparse.dyndns.org>
References: <874pakhist.fsf@sparse.dyndns.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Jason Riedy" <jason@acm.org>,
	<ipw3945-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 01, 2008 11:29 PM,
linux-wireless-owner@vger.kernel.org  wrote:

> The iwl3945 (currently?) does not use iwlcore.  Either the iwlcore
> documentation should change or the option should be silent.  This
> patch follows the latter route.  IWL4965 already SELECTs IWLCORE,
> so there should be no new problems.  Note that IWLWIFI_DEBUGFS and
> IWLCORE_RFKILL have no suboptions for 4965, so they are grouped
> together and given a description that includes "4965+" to indicate
> they're not for the 3945 adapters.
> 
> Signed-off-by: Jason Riedy <jason@acm.org>

We are moving to a common library for the devices and changing
CONFIG_IWLWIFI_DEBUG to CONFIG_IWL4965_DEBUG undoes this work. Please be
patient as we move to common code.

The numerous Kconfig variables help us to add and test the new features
during development. They should not be there permanently.

Reinette
