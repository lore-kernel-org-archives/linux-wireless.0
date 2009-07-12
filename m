Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:59362 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZGLMpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 08:45:41 -0400
Received: by bwz23 with SMTP id 23so373924bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 05:45:40 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: iwlwifi 4965 uCode available
Date: Sun, 12 Jul 2009 14:45:40 +0200
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <1247174482.17896.1304.camel@rc-desk>
In-Reply-To: <1247174482.17896.1304.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907121445.42289.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 9. Juli 2009 schrieb reinette chatre:
> Version 228.61.2.24 of uCode for Intel Wireless WiFi Link 4965AGN is now
> available for download from
> http://intellinuxwireless.org/?n=Downloads

The new ucode seems to cause fw restarts every now and then (together
with wireless-testing).

iwlagn 0000:10:00.0: Microcode SW error detected.  Restarting 0x82000000.

I couldn't figure out how to reproduce this but it happened a few times
now since I switched to the new ucode.

Should I load iwlagn with some special debug flags?

Helmut
