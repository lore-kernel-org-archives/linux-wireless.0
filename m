Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9965 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965322AbXBOIlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 03:41:06 -0500
Received: from lin01.mn-solutions.de (pD95F8F54.dip0.t-ipconnect.de [217.95.143.84])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 499885E40B9
	for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 09:41:03 +0100 (CET)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 1A4D51E002B
	for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 09:40:58 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: How to start with a Marvell driver (non-USB, non-OLPC)
Date: Thu, 15 Feb 2007 09:40:49 +0100
References: <200702090858.26294.hs4233@mail.mn-solutions.de>
In-Reply-To: <200702090858.26294.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702150940.49306.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, I got encouraging replies to my initial mail. Later I 
produced some patches for discussion and posted them into 
libertas-dev and marvell8385-devel@linuxtogo.org.

But besides "please make a git repository" no one really cared 
(about the patches --- there were other reactions). No patch has 
been commented, ridiculed or applied.


If someone is interested, the patches are at
 
http://projects.linuxtogo.org/plugins/scmsvn/viewcvs.php/trunk/patches/?root=marvell8385



I consider

remove-unused-var.patch
remove-boot-command-define.patch
rename-functions.patch
remove-libertas-sbi-get-priv.patch

as applyable to libertas-2.6, the others are work-in-progress.


I'm now in the process to create a git repository at 
infradead.org, maybe this can help the process. However, I don't 
have any idea what I can do if I pushed a changeset to infradead 
and later learn that this is crap. Can I rebase the HEAD of a 
remote git repository?
