Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:63766 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2EOKXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 06:23:02 -0400
Date: Tue, 15 May 2012 12:22:57 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Alex =?UTF-8?B?VmlsbGFjw63CrXM=?= Lasso
	<a_villacis@palosanto.com>
Subject: Re: [PATCH] rt2x00: Add support for RT5360 based PCI devices.
Message-ID: <20120515122257.1e58ee43@north> (sfid-20120515_122307_506160_052A5772)
In-Reply-To: <1336652854-16163-1-git-send-email-gwingerde@gmail.com>
References: <1336652854-16163-1-git-send-email-gwingerde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 10 May 2012 14:27:33 +0200 Gertjan van Wingerde <gwingerde@gmail.com> wrote:
> From: Alex Villací­s Lasso <a villacis@palosanto.com>
> 
> This chip is used at least by the D-Link DWA-525 adapter.

I have some concerns regarding this patch. 

First of all Gertjan, I think you removed define of RF5360 and it
doesn't compile now ;-)

Secondly looking at legacy driver, 5360 is just another PCI ID of 5390
family, do we really need to add all these cases? I think maybe adding
PCI ID, as Zero Lin did recently with 539b will be sufficient? 

  -- Kuba
