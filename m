Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:58107 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1LMM7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:59:33 -0500
Received: from moweb001.kundenserver.de (moweb001.kundenserver.de [172.19.20.114])
	by fmmailgate05.web.de (Postfix) with ESMTP id 6A03D67DCC44
	for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 13:59:32 +0100 (CET)
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/15] brcm80211: the rest of smac bcma switch series
From: Julian Wollrath <jwollrath@web.de>
Date: Tue, 13 Dec 2011 13:59:31 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201112131359.31412.jwollrath@web.de> (sfid-20111213_135937_012296_E8CC94B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> With this set of patches, my BCM43224 works with brcmsmac.
here its also working, with one exception, if I switch the BCM43224 with the 
external switch on my laptop of and then start linux, the laptop freezes 
quietly before completing the boot process. The only complaint a good while 
before freezing is
[   12.298798] brcms_module_init: register returned 0

This problem, without the message above, also occured without this two patch 
series, which enable the use of bcma.


With best regards
Julian Wollrath
