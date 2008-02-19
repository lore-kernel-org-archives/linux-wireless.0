Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbYBSWVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 17:21:38 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi
Date: Tue, 19 Feb 2008 14:20:35 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003AF3178@orsmsx416.amr.corp.intel.com> (sfid-20080219_222141_887674_792CAA7F)
In-Reply-To: <47B631BE.6070704@atsystem.org>
References: <47B631BE.6070704@atsystem.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Antonio Quartulli" <quartulli@atsystem.org>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Antonio Quartulli  wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Why is iwlwifi still at version 1.2.23?
> Is there some problem with it?

I assume you are referring to the out of tree driver available from
intellinuxwireless.org. 

iwlwifi has been included in the kernel since 2.6.24, for this reason
development has shifted to focus on upstream. The repository at
intellinuxwireless.org has not been receiving changes since release of
1.2.23 - all changes go directly upstream. You can use the latest
upstream driver by utilizing the compat-wireless project
(http://linuxwireless.org/en/users/Download). Currently the upstream
driver also has version number 1.2.23 - even tough it received
significant changes since the out of tree release of 1.2.23. To reduce
this confusion we did send a version update to the development tree
(making the in kernel iwlwifi be version 1.2.26), this change is still
to be applied.

Version numbering does make less sense now that we are in the kernel ...
please be assured that you are using the latest driver when you are
using the compat-wireless project.

Reinette
