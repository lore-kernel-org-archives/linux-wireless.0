Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3494 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZI3SD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 14:03:27 -0400
Message-ID: <4AC39D6F.5070308@canonical.com>
Date: Wed, 30 Sep 2009 12:03:27 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iwl-1000 firmware versions 1 and 2 are nowhere to be found
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette,

I've got a user complaining that the iwl-1000 firmware version required
by 2.6.31 doesn't exist. Indeed, IWL1000_UCODE_API_MAX is 2, yet the
only firmware available from http://intellinuxwireless.org/?n=Downloads
is iwlwifi-1000-3.ucode. Shall I just tell him to install compat-wireless ?

BugLink: http://bugs.launchpad.net/bugs/439285

rtg
-- 
Tim Gardner tim.gardner@canonical.com
