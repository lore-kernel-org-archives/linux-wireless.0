Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3308 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1CYQCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 12:02:38 -0400
Message-ID: <4D8CB794.9040102@canonical.com>
Date: Fri, 25 Mar 2011 09:41:08 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 2.6.38 iwlwifi 11n_disable=1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wey-Yi,

The Ubuntu Maverick release (2.6.35) has been carrying a user space 
patch in module-init-tools that disables 802.11n support by default 
using the 11n_disable module parameter. With the split in 2.6.38 into 
iwl3945 and iwlagn is it possible that we could now remove the module 
option for iwlagn? Will the 4965 adapters function correctly with 802.11n?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
