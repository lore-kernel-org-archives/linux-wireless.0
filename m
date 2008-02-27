Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYB0GXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 01:23:46 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Compiler error when compile iwlwifi
Date: Tue, 26 Feb 2008 22:19:02 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003C36C47@orsmsx416.amr.corp.intel.com> (sfid-20080227_062350_271759_1FF6293C)
In-Reply-To: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com>
References: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Elyahou ITTAH" <ittah.elyahou@gmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Elyahou ITTAH  wrote:

> Hi,
> 
> When i try to compile the iwlwifi driver I have got this error:
> http://rafb.net/p/UdH56R87.html
> 
> I have a 2.6.24-r2 gentoo kernel,with the iwlwifi included... -
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The iwlwifi driver development is now focused on upstream so backporting
of the intellinuxwireless.org drivers are only done for kernels
2.6.18-2.6.23. The easiest way to use the latest driver with your kernel
will be to use the compat-wireless project
(http://linuxwireless.org/en/users/Download).

Reinette
