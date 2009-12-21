Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:49321 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZLUBQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 20:16:37 -0500
Received: from [192.168.10.7] (builder.redfish-solutions.com [192.168.10.7])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.3/8.14.3) with ESMTP id nBL1GZLS014438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 18:16:36 -0700
Message-ID: <4B2ECC72.40703@redfish-solutions.com>
Date: Sun, 20 Dec 2009 17:16:34 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Can't turn off SSB (CONFIG_SSB)?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm building images for an EMBEDDED platform, and forcing CONFIG_SSB_POSSIBLE=n, but I'm still seeing:

*
* Sonics Silicon Backplane
*
Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n

Support for the Sonics Silicon Backplane bus.
You only need to enable this option, if you are
configuring a kernel for an embedded system with
this bus.
It will be auto-selected if needed in other
environments.

The module will be called ssb.

If unsure, say N.

Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n

Support for the Sonics Silicon Backplane bus.
You only need to enable this option, if you are
configuring a kernel for an embedded system with
this bus.
It will be auto-selected if needed in other
environments.

The module will be called ssb.

If unsure, say N.

Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) 



And why does arch/x86/configs/i386_defconfig nail up CONFIG_SSB_POSSIBLE?

This is with 2.6.27.38.

And what are the steps to figuring out the dependency that keeps forcing it on?  Something must be doing a "select SSB" but I'm not sure what.



