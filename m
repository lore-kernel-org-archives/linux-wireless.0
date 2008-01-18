Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbYARQJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 11:09:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Subject: RE:  Re: iwl3945 driver is still unusable!
Date: Fri, 18 Jan 2008 08:09:46 -0800
Message-ID: <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com> (sfid-20080118_160951_613222_FFD3ACC3)
In-Reply-To: <fmpigk$c57$1@ger.gmane.org>
References: <fmclu6$dvl$1@ger.gmane.org> <fmpigk$c57$1@ger.gmane.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: =?iso-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
	<linux-wireless@vger.kernel.org>
Cc: <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Thomas B=E4chler  wrote:

> Thomas B=E4chler schrieb:
>> What I need is a solution, meaning either a working iwl3945 version
>> or a patch to ipw3945 to compile with 2.6.24.
>=20
> I was hoping for someone from Intel or someone with knowledge of the
> code to comment on both these issues:
>=20
> - Can ipw3945 be modified to compile with 2.6.24?

ipw3945 is deprecated - we focus our effort on iwlwifi at this time.

> - Can the newest iwl3945 from the website be modified to compile with
> 2.6.24?

iwlwifi is included in 2.6.24 so you can use it from there. If you are =
interested in the latest iwlwifi development (more recent than what is =
in 2.6.24) then you can work from John Linville's wireless-2.6 (#everyt=
hing) repository.

Reinette
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
