Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1405 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYLIOyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 09:54:49 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>, simon@thekelleys.org.uk,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Pavel Roskin <proski@gnu.org>, David Gibson <dwg@au1.ibm.com>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: wireless drivers sparse warnings
Date: Tue, 9 Dec 2008 09:51:39 -0500
Message-Id: <20081209145036.M4166@bobcopeland.com> (sfid-20081209_155452_717134_C2B0EB0C)
In-Reply-To: <1228823435.22164.216.camel@johannes.berg>
References: <1228823435.22164.216.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 09 Dec 2008 12:50:35 +0100, Johannes Berg wrote
> drivers/net/wireless/ath5k/pcu.c:1102:21: warning: restricted __le32
> degrades to integer

Oops, thanks for the heads up.  I'll do a patch for that tonight.

-- 
Bob Copeland %% www.bobcopeland.com


