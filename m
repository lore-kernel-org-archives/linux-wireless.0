Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab3C3Smo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 14:42:44 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Shuduo Sang <sangshuduo@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] [PATCH] iwlwifi: add new pci id for 6x35 series
Date: Sat, 30 Mar 2013 18:40:00 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301964A4B@HASMSX103.ger.corp.intel.com> (sfid-20130330_194248_550684_13CCB02F)
References: <5156859D.4030003@gmail.com>
In-Reply-To: <5156859D.4030003@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> some new thinkpad laptops use intel chip with new pci id need be added lspci -
> vnn output:
>  Network controller [0280]: Intel Corporation Centrino Advanced-N 6235
> [8086:088f] (rev 24)
>  Subsystem: Intel Corporation Device [8086:5260]
> 

Can you please send the exact laptop models?
I would like to do internal inquiries before we merge this patch.
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

