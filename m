Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbYBNXJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 18:09:12 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] ipw2200: fix ucode assertion for RX queue overrun
Date: Thu, 14 Feb 2008 14:59:44 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABCB43@orsmsx416.amr.corp.intel.com> (sfid-20080214_230916_602047_89C300B0)
In-Reply-To: <1203029381.6570.1.camel@localhost.localdomain>
References: <1203029381.6570.1.camel@localhost.localdomain>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Dan Williams" <dcbw@redhat.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw2100-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 14, 2008 2:50 PM, Dan Williams  wrote:

> Restock the RX queue when there are a lot of unused frames so that the
> RX ring buffer doesn't overrun, causing a ucode assertion.  Backport
> of patch "iwlwifi: fix ucode assertion for RX queue overrun".
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you very much

Reinette
