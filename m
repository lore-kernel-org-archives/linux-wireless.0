Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYDRWfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 18:35:22 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: RE: iwl3945 problem with 2.6.25-rc9
Date: Fri, 18 Apr 2008 15:35:21 -0700
Message-ID: <D936D925018D154694D8A362EEB089200438B79F@orsmsx416.amr.corp.intel.com> (sfid-20080418_233527_245462_09B925D8)
In-Reply-To: <20080418232358.000fbdf7@peterson.fenrir.org.uk>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com><fu5iel$c45$1@ger.gmane.org><fu5l5r$pm8$1@ger.gmane.org><1208376292.27708.3.camel@localhost.localdomain><D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com><D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com><fu931e$k1b$1@ger.gmane.org><D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com><1208555842.4848.56.camel@johannes.berg><D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com> <20080418232358.000fbdf7@peterson.fenrir.org.uk>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Brian Morrison" <bdm@fenrir.org.uk>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Brian Morrison  wrote:

> Not wishing to muddy the waters, but I've found that the iwlwifi
> driver with a 3945 card is only reliable for scanning and associating
> for 
> my laptop (x86_64) with disable_hw_scan=1 set, this is with
> 2.4.24.4-64.fc8 kernel. Driver version is 1.2.26.

I agree that your problem is related (no scanning results from driver),
but it does seem to be different from what we are trying to debug here.
In this case the user is not receiving scanning results when using sw
scanning while the driver should have been using hw scanning because the
user is not using that driver parameter as you are.

Reinette
