Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47849 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYBLW5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 17:57:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
Date: Tue, 12 Feb 2008 23:56:40 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200802122205.42799.mb@bu3sch.de>
In-Reply-To: <200802122205.42799.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802122356.40865.mb@bu3sch.de> (sfid-20080212_225710_606811_5B828CAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 22:05:42 Michael Buesch wrote:
> This patch adds QOS support for b43.
> Please comment on this and test this.
> This patch depends on Johannes' "burst time -> txop patch" being _not_ applied.
> One can trivially fix that, though.

Hm, it seems there are two other variables in SHM we should probably write:
 0x000E  EDCF Status Offset
 0x0030  TXF Current Index

The status offset is the offset of the status field in the QOS data structure
for a queue?
What is the TXF Current Index?

-- 
Greetings Michael.
